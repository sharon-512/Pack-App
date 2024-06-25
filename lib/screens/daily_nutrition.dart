import 'package:flutter/material.dart';
import 'package:pack_app/screens/summary_screen.dart';

import '../custom_style.dart';
import '../widgets/Addon_item.dart';
import '../widgets/common_button.dart';
import '../widgets/food_detail_container.dart';

class DailyNutrition extends StatefulWidget {
  const DailyNutrition({super.key});

  @override
  State<DailyNutrition> createState() => _DailyNutritionState();
}

class _DailyNutritionState extends State<DailyNutrition> {
  int selectedDay = 0;
  int selectedFoodOption = 0;
  int selectedCardIndex = -1;

  @override
  Widget build(BuildContext context) {
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
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      // Define the texts for each container
                      String text1 = 'Apr';
                      String text2 = (21 + index).toString();
                      String text3 = [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat'
                      ][index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = index; // Update the selected index
                          });
                        },
                        child: Row(
                          children: [
                            CustomContainer(
                              index == selectedDay,
                              text1,
                              text2,
                              text3,
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffFFF7E2),
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
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: selectedFoodOption == index
                                ? Color(0xFFFEC66F)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: selectedFoodOption == index
                                  ? Color(0xFFFEC66F)
                                  : Colors
                                  .transparent, // Same border color for all
                            ),
                          ),
                          child: Center(
                            child: Text(
                              foodOptions[index],
                              style: TextStyle(
                                  color: selectedFoodOption == index
                                      ? Colors.black
                                      : Color(0xFFA89B87),
                                  fontSize: 13,
                                  fontFamily: 'Aeonik',
                                  letterSpacing: .14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: selectedFoodOption == 0
                          ? List.generate(
                        8,
                            (index) => FoodInfoCard(
                          isSelected: selectedCardIndex == index,
                          onTap: () {
                            setState(() {
                              selectedCardIndex = index;
                            });
                          },
                        ),
                      )
                          : selectedFoodOption == 4
                          ? List.generate(
                        8,
                            (index) => AddonItem(
                          onTap: () {
                            setState(() {
                              selectedCardIndex = index;
                            });
                          },
                        ),
                      )
                          : [],
                    ),
                  ),
                )
              ],
            ),
            CommonButton(
              text: 'Continue',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SummaryScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomContainer(
      bool isSelected,
      String text1,
      String text2,
      String text3,
      ) {
    return Container(
      height: 90,
      width: 69,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFEDC0B2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEDC0B2), // Thicker border if selected
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text1,
            style: CustomTextStyles.labelTextStyle
                .copyWith(color: isSelected ? Colors.white : Colors.black),
          ),
          Text(
            text2,
            style: CustomTextStyles.labelTextStyle.copyWith(
                fontSize: 24, color: isSelected ? Colors.white : Colors.black),
          ),
          Text(
            text3,
            style: CustomTextStyles.labelTextStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xffABABAB)),
          ),
        ],
      ),
    );
  }

}
