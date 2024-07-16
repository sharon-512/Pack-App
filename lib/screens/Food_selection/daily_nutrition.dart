import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pack_app/screens/Food_selection/widgets/Addon_item.dart';
import 'package:pack_app/screens/Food_selection/widgets/date_selection.dart';
import 'package:pack_app/screens/Food_selection/widgets/food_detail_container.dart';
import 'package:pack_app/screens/Food_selection/widgets/food_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../custom_style.dart';
import '../../widgets/Shimmer.dart';
import '../../widgets/common_button.dart';
import '../Summary/summary_screen.dart';

class DailyNutrition extends StatefulWidget {
  final int subplanId;
  final int mealtypeId;
  final int numberofMeals;

  const DailyNutrition({
    Key? key,
    required this.subplanId,
    required this.mealtypeId,
    required this.numberofMeals
  }) : super(key: key);

  @override
  State<DailyNutrition> createState() => _DailyNutritionState();
}

class _DailyNutritionState extends State<DailyNutrition> {
  int selectedDay = 0;
  int selectedFoodOption = 0;
  int selectedCardIndex = -1;
  Map<String, dynamic>? foodDetails;
  List<dynamic>? addons;
  late DateTime startDate;
  late DateTime endDate;
  bool _isLoading = true;
  int selectedBreakfastCardIndex = -1;
  int selectedBreakfastMenuId = -1;
  int selectedLunchCardIndex = -1;
  int selectedLunchMenuId = -1;
  int selectedSnacksCardIndex = -1;
  int selectedSnacksMenuId = -1;
  int selectedDinnerCardIndex = -1;
  int selectedDinnerMenuId = -1;
  int selectedAddonsCardIndex = -1;

  int selectedCount = 0;
  List<Map<String, dynamic>> dailySelections = [];

  @override
  void initState() {
    super.initState();
    fetchDatesFromSharedPreferences();
    fetchAddons();
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
        dailySelections.add({
          'date': currentDate,
          'breakfast': null,
          'lunch': null,
          'snacks': null,
          'dinner': null,
          'addons': []
        });
      }
    }
  }

  int calculateDaysDifference(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  Future<void> fetchFoodDetails(int subplanId, int mealtypeId) async {
    try {
      final response = await http.get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

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
            });
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
      final response = await http.get(Uri.parse('https://interfuel.qa/packupadmin/api/addons'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          addons = data['data'];
        });
      } else {
        throw Exception('Failed to load addons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching addons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int limit = widget.numberofMeals;

    // Check if selections are complete for all days
    bool isSelectionComplete = dailySelections.every((selection) =>
    selection['breakfast'] != null &&
        selection['lunch'] != null &&
        selection['snacks'] != null &&
        selection['dinner'] != null &&
        selection['addons'].isNotEmpty
    );

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
                    });
                  },
                ),
                const SizedBox(height: 20),
                FoodOptions(
                  selectedFoodOption: selectedFoodOption,
                  onSelectFoodOption: (index) {
                    setState(() {
                      selectedFoodOption = index;
                    });
                    if (selectedFoodOption == 4) {
                      fetchAddons();
                    }
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedFoodOption == 0)
                          ...List.generate(
                            foodDetails?['BreakFast']?.length ?? 0,
                                (index) {
                              if (foodDetails?['BreakFast'] == null || foodDetails?['BreakFast']!.isEmpty) {
                                return ShimmerEffect(); // Placeholder when loading
                              }
                              return FoodInfoCard(
                                isSelected: dailySelections[selectedDay]['breakfast'] == foodDetails?['BreakFast'][index],
                                onTap: () {
                                  setState(() {
                                    if (dailySelections[selectedDay]['breakfast'] == foodDetails?['BreakFast'][index]) {
                                      // If already selected, deselect
                                      dailySelections[selectedDay]['breakfast'] = null;
                                      selectedBreakfastCardIndex = -1;
                                      selectedBreakfastMenuId = -1;
                                      selectedCount--;
                                      print('513 -ve ---> $selectedCount');
                                    } else if (selectedCount < limit) {
                                      // Otherwise, select the new item if limit not reached
                                      selectedCount++;
                                      print('513 +ve---> $selectedCount');
                                      dailySelections[selectedDay]['breakfast'] = foodDetails?['BreakFast'][index];
                                      selectedBreakfastCardIndex = index;
                                      selectedBreakfastMenuId = foodDetails?['BreakFast'][index]['menu_id'];
                                    }
                                  });
                                },
                                foodData: foodDetails?['BreakFast'][index],
                              );
                            },
                          ),
                        if (selectedFoodOption == 1)
                          ...List.generate(
                            foodDetails?['Lunch']?.length ?? 0,
                                (index) {
                              if (foodDetails?['Lunch'] == null || foodDetails?['Lunch']!.isEmpty) {
                                return ShimmerEffect(); // Placeholder when loading
                              }
                              return FoodInfoCard(
                                isSelected: dailySelections[selectedDay]['lunch'] == foodDetails?['Lunch'][index],
                                onTap: () {
                                  setState(() {
                                    if (dailySelections[selectedDay]['lunch'] == foodDetails?['Lunch'][index]) {
                                      // If already selected, deselect
                                      dailySelections[selectedDay]['lunch'] = null;
                                      selectedBreakfastCardIndex = -1;
                                      selectedBreakfastMenuId = -1;
                                      selectedCount--;
                                    } else if (selectedCount < limit) {
                                      // Otherwise, select the new item if limit not reached
                                      selectedCount++;
                                      dailySelections[selectedDay]['lunch'] = foodDetails?['Lunch'][index];
                                      selectedBreakfastCardIndex = index;
                                      selectedBreakfastMenuId = foodDetails?['Lunch'][index]['menu_id'];
                                    }
                                  });
                                },
                                foodData: foodDetails?['Lunch'][index],
                              );
                            },
                          ),
                        if (selectedFoodOption == 2)
                          ...List.generate(
                            foodDetails?['Snacks']?.length ?? 0,
                                (index) {
                              if (foodDetails?['Snacks'] == null || foodDetails?['Snacks']!.isEmpty) {
                                return ShimmerEffect(); // Placeholder when loading
                              }
                              return FoodInfoCard(
                                isSelected: dailySelections[selectedDay]['snacks'] == foodDetails?['Snacks'][index],
                                onTap: () {
                                  setState(() {
                                    if (dailySelections[selectedDay]['snacks'] == foodDetails?['Snacks'][index]) {
                                      // If already selected, deselect
                                      dailySelections[selectedDay]['snacks'] = null;
                                      selectedBreakfastCardIndex = -1;
                                      selectedBreakfastMenuId = -1;
                                      selectedCount--;
                                    } else if (selectedCount < limit) {
                                      // Otherwise, select the new item if limit not reached
                                      selectedCount++;
                                      dailySelections[selectedDay]['snacks'] = foodDetails?['Snacks'][index];
                                      selectedBreakfastCardIndex = index;
                                      selectedBreakfastMenuId = foodDetails?['Snacks'][index]['menu_id'];
                                    }
                                  });
                                },
                                foodData: foodDetails?['Snacks'][index],
                              );
                            },
                          ),
                        if (selectedFoodOption == 3)
                          ...List.generate(
                            foodDetails?['Dinner']?.length ?? 0,
                                (index) {
                              if (foodDetails?['Dinner'] == null || foodDetails?['Dinner']!.isEmpty) {
                                return ShimmerEffect(); // Placeholder when loading
                              }
                              return FoodInfoCard(
                                isSelected: dailySelections[selectedDay]['dinner'] == foodDetails?['Dinner'][index],
                                onTap: () {
                                  setState(() {
                                    if (dailySelections[selectedDay]['dinner'] == foodDetails?['Dinner'][index]) {
                                      // If already selected, deselect
                                      dailySelections[selectedDay]['dinner'] = null;
                                      selectedBreakfastCardIndex = -1;
                                      selectedBreakfastMenuId = -1;
                                      selectedCount--;
                                    } else if (selectedCount < limit) {
                                      // Otherwise, select the new item if limit not reached
                                      selectedCount++;
                                      dailySelections[selectedDay]['dinner'] = foodDetails?['Dinner'][index];
                                      selectedBreakfastCardIndex = index;
                                      selectedBreakfastMenuId = foodDetails?['Dinner'][index]['menu_id'];
                                    }
                                  });
                                },
                                foodData: foodDetails?['Dinner'][index],
                              );
                            },
                          ),
                        if (selectedFoodOption == 4)
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
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CommonButton(
              text: 'Continue',
              onTap: () {
                bool isComplete = true;

                // Check if the required number of meals are selected for each day
                for (var selection in dailySelections) {
                  int selectedCount = 0;

                  // Count selected meals for the current day
                  if (selection['breakfast'] != null) selectedCount++;
                  if (selection['lunch'] != null) selectedCount++;
                  if (selection['snacks'] != null) selectedCount++;
                  if (selection['dinner'] != null) selectedCount++;
                  // Check if selected count matches numberofMeals
                  if (selectedCount != widget.numberofMeals) {
                    isComplete = false;
                    break;
                  }
                }

                if (isComplete) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(),
                    ),
                  );
                } else {
                  // Optionally show a message or handle incomplete selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select meals for each day.'),
                      duration: Duration(seconds: 2), // Adjust duration as needed

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

}