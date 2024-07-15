import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../custom_style.dart';
import '../widgets/Addon_item.dart';
import '../widgets/common_button.dart';
import '../widgets/food_detail_container.dart';
import '../screens/summary_screen.dart';
import 'package:shimmer/shimmer.dart';

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
                Container(
                  height: 92,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dailySelections.length,
                    itemBuilder: (context, index) {
                      DateTime currentDate = dailySelections[index]['date'];
                      String text1 = DateFormat('MMM').format(currentDate);
                      String text2 = DateFormat('d').format(currentDate);
                      String text3 = DateFormat('E').format(currentDate);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCount = 0;
                            print('512 ---> $selectedCount');
                            selectedDay = index;
                          });
                        },
                        child: Row(
                          children: [
                            CustomContainer(
                              isSelected: index == selectedDay,
                              text1: text1,
                              text2: text2,
                              text3: text3,
                            ),
                            SizedBox(width: 10)
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF7E2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      // Define a list of food options
                      List<String> foodOptions = [
                        'Breakfast',
                        'Lunch',
                        'Snacks',
                        'Dinner',
                        'Addons'
                      ];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFoodOption =
                                index; // Update the selected item index
                          });
                          if (selectedFoodOption == 4) {
                            fetchAddons(); // Fetch addons when "Addons" is selected
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: selectedFoodOption == index
                                ? const Color(0xFFFEC66F)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: selectedFoodOption == index
                                  ? const Color(0xFFFEC66F)
                                  : Colors.transparent, // Same border color for all
                            ),
                          ),
                          child: Center(
                            child: Text(
                              foodOptions[index],
                              style: TextStyle(
                                color: selectedFoodOption == index
                                    ? Colors.black
                                    : const Color(0xFFA89B87),
                                fontSize: 13,
                                fontFamily: 'Aeonik',
                                letterSpacing: 0.14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
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
                                return _buildShimmerEffect(); // Placeholder when loading
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
                                      //if (selectedBreakfastCardIndex == -1)
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
                                return _buildShimmerEffect(); // Placeholder when loading
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
                                      //if (selectedBreakfastCardIndex == -1)
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
                                return _buildShimmerEffect(); // Placeholder when loading
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
                                      //if (selectedBreakfastCardIndex == -1)
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
                                return _buildShimmerEffect(); // Placeholder when loading
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
                                      //if (selectedBreakfastCardIndex == -1)
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
                                return _buildShimmerEffect(); // Placeholder when loading
                              }
                              return FoodInfoCard(
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
                                foodData: addons![index],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(
                      // selectedBreakfastMenuId: selectedBreakfastMenuId,
                      // selectedDinnerMenuId: selectedDinnerMenuId,
                      // selectedSnacksMenuId: selectedSnacksMenuId,
                      // selectedLunchMenuId: selectedLunchMenuId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 120.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}


class CustomContainer extends StatelessWidget {
  final bool isSelected;
  final String text1;
  final String text2;
  final String text3;

  const CustomContainer({
    Key? key,
    required this.isSelected,
    required this.text1,
    required this.text2,
    required this.text3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 69,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEDC0B2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEDC0B2), // Thicker border if selected
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text1,
            style: CustomTextStyles.labelTextStyle.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            text2,
            style: CustomTextStyles.labelTextStyle.copyWith(
              fontSize: 24,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            text3,
            style: CustomTextStyles.labelTextStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xffABABAB),
            ),
          ),
        ],
      ),
    );
  }
}
