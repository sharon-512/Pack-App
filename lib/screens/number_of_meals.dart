import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_style.dart';
import '../widgets/common_button.dart';
import 'daily_nutrition.dart';
import 'date_picker.dart';

class NumberOfMeals extends StatefulWidget {
  const NumberOfMeals({Key? key}) : super(key: key);

  @override
  State<NumberOfMeals> createState() => _NumberOfMealsState();
}

class _NumberOfMealsState extends State<NumberOfMeals> {
  int selectedOption = 0; // 0 for none, 1 for Day Pack, 2 for One Week, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Select the no.of meals per day',
                        style: CustomTextStyles.titleTextStyle,
                      ),
                      const SizedBox(height: 50),
                      // Options are generated here
                      for (int i = 1; i <= 4; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = i;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                            decoration: BoxDecoration(
                              color: selectedOption == i
                                  ? Color(0xFFEDC0B2)
                                  : Colors.transparent,
                              border: Border.all(color: Color(0xFFEDC0B2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                _getTextForOption(i),
                                style: TextStyle(
                                  color: selectedOption == i
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: 'Aeonik',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You can freeze your plan through your profile. this is a weekly ongoing subscription. you can freeze up to 3 days',
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                CommonButton(
                  text: 'Continue',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyNutrition(),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getTextForOption(int option) {
    switch (option) {
      case 1:
        return 'One Meal';
      case 2:
        return 'Two Meal';
      case 3:
        return 'Three Meal';
      case 4:
        return 'Four Meal';
      default:
        return '';
    }
  }
}
