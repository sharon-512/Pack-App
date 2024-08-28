import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pack_app/screens/Food_selection/widgets/Addon_item.dart';
import 'package:pack_app/screens/Food_selection/widgets/date_selection.dart';
import 'package:pack_app/screens/Food_selection/widgets/food_detail_container.dart';
import 'package:pack_app/screens/Food_selection/widgets/food_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../custom_style.dart';
import '../../services/api.dart';
import '../../widgets/Shimmer.dart';
import '../../widgets/common_button.dart';
import '../../widgets/no_network_widget.dart';
import '../Summary/summary_screen.dart';

class DailyNutrition extends StatefulWidget {
  final int subplanId;
  final int mealtypeId;
  final int numberofMeals;

  const DailyNutrition(
      {Key? key,
      required this.subplanId,
      required this.mealtypeId,
      required this.numberofMeals})
      : super(key: key);

  @override
  State<DailyNutrition> createState() => _DailyNutritionState();
}

class _DailyNutritionState extends State<DailyNutrition> {
  int selectedDay = 0;
  int selectedFoodOption = 0;
  Map<String, dynamic>? foodDetails;
  List<dynamic>? addons;
  late DateTime startDate;
  late DateTime endDate;
  String foodPrice = '';
  bool _isLoading = true;
  int selectedPlanId = -1;
  String selectedPlanName = '';
  String planImage = '';
  int selectedCount = 0;
  List<Map<String, dynamic>> dailySelections = [];
  List<Map<String, dynamic>> selectedAddonsFinal = [];
  double totalPrice = 0.0;
  double subtotalAddonPrice = 0.0;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<String> mealCategories = [];



  @override
  void initState() {
    super.initState();
    fetchDatesFromSharedPreferences();
    fetchAddons();
    fetchFoodPrice(widget.subplanId, widget.mealtypeId);
    clearSharedPreferences();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus.last == ConnectivityResult.none) {
      print('No internet connection');
    } else {
      print('Connected to the internet');
    }
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('subtotalAddonPrice');
    print('Shared preferences cleared');
  }

  Future<void> updateSubtotalAddonPrice(double totalPrice) async {
    final prefs = await SharedPreferences.getInstance();
    subtotalAddonPrice = (prefs.getDouble('subtotalAddonPrice') ?? 0.0) + totalPrice;
    await prefs.setDouble('subtotalAddonPrice', subtotalAddonPrice);
    print('Updated Subtotal Addon Price in SharedPreferences: $subtotalAddonPrice');
  }

  Future<void> fetchDatesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedStartDate = prefs.getString('startDate');
    final storedEndDate = prefs.getString('endDate');

    if (storedStartDate != null && storedEndDate != null) {
      setState(() {
        startDate = DateFormat('EEEE, MMMM d, yyyy').parse(storedStartDate);
        endDate = DateFormat('EEEE, MMMM d, yyyy').parse(storedEndDate);
        _isLoading = false;
        initializeDailySelections(startDate, endDate);
      });
    } else {
      setState(() {
        startDate = DateTime.now();
        endDate = DateTime.now();
        _isLoading = false;
        initializeDailySelections(startDate, endDate);
      });
    }

    fetchFoodDetails(widget.subplanId, widget.mealtypeId);
  }

  void initializeDailySelections(DateTime start, DateTime end) {
    int days = calculateDaysDifference(start, end);
    for (int i = 0; i <= days; i++) {
      DateTime currentDate = start.add(Duration(days: i));
      if (currentDate.weekday != DateTime.friday) {
        Map<String, dynamic> daySelection = {'date': currentDate, 'addons': []};

        for (String category in mealCategories) {
          daySelection[category] = null;
        }

        dailySelections.add(daySelection);
      }
    }
  }

  int calculateDaysDifference(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  Future<void> fetchFoodPrice(int subplanId, int mealtypeId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/get-diet-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Find the selected subplan
        Map<String, dynamic>? selectedSubplan;
        for (var plan in data['plan']) {
          for (var subplan in plan['sub_plans']) {
            if (subplan['subplan_id'] == subplanId) {
              selectedSubplan = subplan;
              selectedPlanId = plan['plan_id']; // Store the plan_id here
              selectedPlanName = plan['plan_name']; // Store the plan_name here
              planImage = plan['plan_image'];
              break;
            }
          }
          if (selectedSubplan != null) break;
        }

        if (selectedSubplan != null) {
          // Find the selected meal type within the selected subplan
          Map<String, dynamic>? selectedMealType;
          for (var mealType in selectedSubplan['meal_plan']) {
            if (mealType['mealtype_id'] == mealtypeId) {
              selectedMealType = mealType;
              break;
            }
          }

          if (selectedMealType != null) {
            // Extract the price as a string from the selected meal type
            String? price = selectedMealType['products']['price'];
            setState(() {
              foodPrice = price!; // Assign the price to state variable
              // Assign plan details to state variables
            });
            print('Price fetched: $foodPrice');
            print('Selected Plan ID: $selectedPlanId');
            print('Selected Plan Name: $selectedPlanName');
          } else {
            throw Exception('Selected meal type not found');
          }
        } else {
          throw Exception('Selected subplan not found');
        }
      } else {
        throw Exception('Failed to load food details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching food details: $e');
    }
  }

  Future<void> fetchFoodDetails(int subplanId, int mealtypeId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/get-diet-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        Map<String, dynamic>? selectedSubplan;
        for (var plan in data['plan']) {
          for (var subplan in plan['sub_plans']) {
            if (subplan['subplan_id'] == subplanId) {
              selectedSubplan = subplan;
              break;
            }
          }
          if (selectedSubplan != null) break;
        }

        if (selectedSubplan != null) {
          Map<String, dynamic>? selectedMealType;
          for (var mealType in selectedSubplan['meal_plan']) {
            if (mealType['mealtype_id'] == mealtypeId) {
              selectedMealType = mealType;
              break;
            }
          }

          if (selectedMealType != null) {
            setState(() {
              foodDetails = selectedMealType?['products'];

              // Populate mealCategories with only valid categories (i.e., lists of products)
              mealCategories = (selectedMealType?['products'] as Map<String, dynamic>).keys
                  .where((key) => selectedMealType?['products'][key] is List)
                  .toList();
            });

            print('Meal Categories: $mealCategories');
          } else {
            throw Exception('Selected meal type not found');
          }
        } else {
          throw Exception('Selected subplan not found');
        }
      } else {
        throw Exception('Failed to load food details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching food details: $e');
    }
  }

  Future<void> fetchAddons() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/addons'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          addons = data['data'];
        });
        for (var addon in addons!) {
        }
      } else {
        throw Exception('Failed to load addons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching addons: $e');
    }
  }


  void handleFoodSelection(String mealType, int index, dynamic foodItem) {
    setState(() {
      if (dailySelections[selectedDay][mealType] != null) {
        selectedCount--;
      }

      if (dailySelections[selectedDay][mealType] == foodItem) {
        dailySelections[selectedDay][mealType] = null;
      } else if (selectedCount < widget.numberofMeals) {
        selectedCount++;
        dailySelections[selectedDay][mealType] = foodItem;
      }
    });
  }

  Widget buildFoodOptions(String mealType) {
    final foodList = foodDetails?[mealType];

    if (foodList == null || foodList.isEmpty) {
      return ShimmerEffect();
    }

    return Column(
      children: List.generate(foodList.length, (index) {
        return FoodInfoCard(
          isSelected: dailySelections[selectedDay][mealType] == foodList[index],
          onTap: () => handleFoodSelection(mealType, index, foodList[index]),
          foodData: foodList[index],
        );
      }),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
    final int limit = widget.numberofMeals;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pick your daily nutrition',
                  style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 30),
                ),
                const SizedBox(height: 20),
                DateSelection(
                  selectedDay: selectedDay,
                  dailySelections: dailySelections,
                  onDateSelected: (index) {
                    setState(() {
                      selectedCount = 0;
                      selectedDay = index;

                      // Loop over mealCategories to count selected meals dynamically
                      for (String category in mealCategories) {
                        if (dailySelections[selectedDay][category] != null) {
                          selectedCount++;
                        }
                      }

                      print('Selected count for day $selectedDay: $selectedCount');
                    });
                  },
                ),
                const SizedBox(height: 20),
                FoodOptions(
                  foodOptions: mealCategories,
                  selectedFoodOption: selectedFoodOption,
                  onSelectFoodOption: (index) {
                    setState(() {
                      selectedFoodOption = index;
                    });
                    if (selectedFoodOption == mealCategories.length - 1) {
                      fetchAddons();
                    }
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedFoodOption < mealCategories.length)
                            buildFoodOptions(mealCategories[selectedFoodOption]),
                          if (selectedFoodOption == mealCategories.length) // Assuming last option is for addons
                            ...List.generate(
                              addons?.length ?? 0,
                                  (index) {
                                if (addons == null || addons!.isEmpty) {
                                  return ShimmerEffect(); // Placeholder when loading
                                }
                                return AddonItem(
                                  isSelected: dailySelections[selectedDay]['addons'].contains(addons![index]),
                                  onTap: () {
                                    setState(() {
                                      if (dailySelections[selectedDay]['addons'].contains(addons![index])) {
                                        dailySelections[selectedDay]['addons'].remove(addons![index]);
                                      } else {
                                        dailySelections[selectedDay]['addons'].add(addons![index]);
                                      }
                                    });
                                  },
                                  addonData: addons![index],
                                  onCountChange: (addonId, quantity, totalPrice) {

                                    // Check if addonId already exists in selectedAddons
                                    int existingIndex = selectedAddonsFinal.indexWhere((addon) => addon['id'] == addonId);

                                    if (existingIndex != -1) {
                                      // If addon exists, update its quantity
                                      setState(() {
                                        selectedAddonsFinal[existingIndex]['quantity'] = quantity;
                                      });
                                    } else {
                                      // If addon doesn't exist, add it to selectedAddons
                                      setState(() {
                                        selectedAddonsFinal.add({'id': addonId, 'quantity': quantity});
                                      });
                                    }
                                    // Print updated selectedAddons (for debugging)
                                    print('Updated selectedAddons: $selectedAddonsFinal');
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            CommonButton(
              text: 'Continue',
              onTap: () async {
                bool isComplete = true;
                // Check if the required number of meals are selected for each day
                for (var selection in dailySelections) {
                  int selectedCount = 0;

                  // Count selected meals for the current day dynamically
                  for (String category in mealCategories) {
                    if (selection[category] != null) {
                      selectedCount++;
                    }
                  }

                  // Check if selected count matches numberofMeals
                  if (selectedCount != widget.numberofMeals) {
                    isComplete = false;
                    break;
                  }
                }

                if (isComplete) {
                  print(foodPrice);
                  List<Map<String, dynamic>> selectedAddons =
                      transformSelectedAddons();
                  List<Map<String, dynamic>> transformedSelections =
                      transformDailySelections();
                  final prefs = await SharedPreferences.getInstance();
                  final subtotalAddonPrice = prefs.getDouble('subtotalAddonPrice') ?? 0;
                  print(transformedSelections);
                  print(selectedAddons);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        planId: selectedPlanId,
                        foodPrice: foodPrice,
                        subplanId: widget.subplanId,
                        mealtypeId: widget.mealtypeId,
                        planName: selectedPlanName,
                        addonPrice: subtotalAddonPrice,
                        dailySelections: transformedSelections,
                        selectedAddons: selectedAddonsFinal,
                        planImage: planImage,
                      ),
                    ),
                  );
                  print(subtotalAddonPrice);
                } else {
                  // Optionally show a message or handle incomplete selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select meals for each day.'),
                      duration:
                          Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> transformSelectedAddons() {
    List<Map<String, dynamic>> addonsList = [];

    // Iterate over each day's addon selection
    for (var daySelection in dailySelections) {
      // Iterate over addons selected for each day
      for (var addon in daySelection['addons']) {
        // Find existing addon in addonsList
        int existingIndex =
            addonsList.indexWhere((a) => a['id'] == addon['id']);

        if (existingIndex != -1) {
          // If addon exists, update its quantity
          addonsList[existingIndex]['quantity'] += 1;
        } else {
          // If addon doesn't exist, add it to addonsList
          addonsList.add({'id': addon['id'], 'quantity': 1});
        }
      }
    }

    return addonsList;
  }

  List<Map<String, dynamic>> transformDailySelections() {
    return dailySelections.map((selection) {
      Map<String, dynamic> transformedSelection = {
        'date': DateFormat('dd-MM-yyyy').format(selection['date']),
      };

      for (String category in mealCategories) {
        transformedSelection[category] = selection[category] != null
            ? selection[category]['menu_id'].toString()
            : '';
      }

      return transformedSelection;
    }).toList();
  }
}
