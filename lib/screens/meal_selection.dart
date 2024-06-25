import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_style.dart';
import '../widgets/common_button.dart';
import 'date_picker.dart';

class MealSelection extends StatefulWidget {
  const MealSelection({Key? key}) : super(key: key);

  @override
  State<MealSelection> createState() => _MealSelectionState();
}

class _MealSelectionState extends State<MealSelection> {
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
                        'Choose Your Meal\nDuration?',
                        style: CustomTextStyles.titleTextStyle,
                      ),
                      const SizedBox(height: 50),
                      // Options are generated here
                      for (int i = 1; i <= 5; i++)
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
            CommonButton(
              text: 'Continue',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DatePicker(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String _getTextForOption(int option) {
    switch (option) {
      case 1:
        return 'Day Pack';
      case 2:
        return 'One Week';
      case 3:
        return 'Two Weeks';
      case 4:
        return 'Three Weeks';
      case 5:
        return '1 Month';
      default:
        return '';
    }
  }
}
