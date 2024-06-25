import 'package:flutter/material.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:pack_app/widgets/selected_food_card.dart';

import '../../../custom_style.dart';

class SelectedMeals extends StatefulWidget {
  const SelectedMeals({super.key});

  @override
  State<SelectedMeals> createState() => _SelectedMealsState();
}

class _SelectedMealsState extends State<SelectedMeals> {
  int selectedDay = 0;
  int selectedFoodOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreenAppBar(showBackButton: false, titleText: 'Selected Meals'),
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    3,
                        (index) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                          child: SelectedFoodCard(),
                        )),
              ),
            ),
          ),
        ],
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
