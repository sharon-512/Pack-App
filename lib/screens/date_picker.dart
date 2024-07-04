import 'package:flutter/material.dart';
import '../custom_style.dart';
import '../widgets/common_button.dart';
import 'daily_nutrition.dart';
import 'package:intl/intl.dart';

import 'number_of_meals.dart';


class DatePicker extends StatelessWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController start = TextEditingController();
    final TextEditingController end = TextEditingController();

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
                const SizedBox(
                  height: 15,
                ),
                Container(
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
                const SizedBox(height: 30),
                Text(
                  'Pick your starting date',
                  style: CustomTextStyles.titleTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  'Starting Day',
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    DateSelectionField(
                        hintText: 'Sunday, April 21, 2024', controller: start),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Ending Day',
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    DateSelectionField(
                        hintText: 'Sunday, April 28, 2024', controller: end),
                  ],
                ),
                const SizedBox(height: 20),
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
                          builder: (context) => const NumberOfMeals(),
                        ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DateSelectionField extends StatelessWidget {
  DateSelectionField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
  });

  final String hintText;
  final TextEditingController controller;
  TextInputType? keyboardType = TextInputType.text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          // Call the date picker on tap
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000), // Adjust as needed
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            // Format and set the date in the controller
            String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(pickedDate);
            controller.text = formattedDate;
          }
        },
        child: IgnorePointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEDC0B2)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEDC0B2)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: hintText,
              hintStyle: CustomTextStyles.hintTextStyle,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
              // Add the calendar icon inside the text field
              suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(0xffD8D8D8),),
            ),
            keyboardType: keyboardType,
            readOnly: true, // Make the text field read-only
          ),
        ),
      ),
    );
  }
}

