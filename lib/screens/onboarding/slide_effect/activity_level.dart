import 'package:flutter/material.dart';

import '../../../custom_style.dart';

class ActivityLevelSelection2 extends StatefulWidget {
  const ActivityLevelSelection2({super.key});

  @override
  State<ActivityLevelSelection2> createState() =>
      _SelectActivityLevelSelection2();
}

class _SelectActivityLevelSelection2 extends State<ActivityLevelSelection2> {
  int _selectedIndex = -1; // Initial value for no selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              'How would you describe\nyour activity level?',
              style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            children: [
              _buildContainer(
                  0,
                  'Quite active',
                  'You engage in any form physical activity\nthroughout the day, such as walking',
                  'activity1.png'), // Customize these texts for each container
              _buildContainer(
                  1,
                  'Very active',
                  'You have an exceptionally high level\nof physical activity',
                  'acti.png'), // Customize these texts for each container
              _buildContainer(
                  2,
                  'Sedentary',
                  'You spend most of their day sitting or\nlying down.',
                  'activity3.png'), // Customize these texts for each container
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(int index, String text1, String text2, String image) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
      },
      child: Container(
        height: 90,
        // Set your desired height
        width: double.infinity,
        // Set your desired width
        decoration: BoxDecoration(
            color: isSelected ? Color(0xFFEDC0B2) : Colors.transparent,
            border: Border.all(color: Color(0xFFEDC0B2)),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(bottom: 16),
        // Space between containers
        child: Row(
          children: [
            SizedBox(width: 10),
            Image.asset('assets/images/$image'), // Add your image path here
            SizedBox(width: 10), // Spacing between image and text
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontFamily: 'Aeonik',
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    text2,
                    style: TextStyle(
                      fontFamily: 'Aeonik',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : Color(0xffCDD1D6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
