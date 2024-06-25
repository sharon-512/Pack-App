import 'package:flutter/material.dart';

import '../../../custom_style.dart';

class SpecificFood2 extends StatefulWidget {
  const SpecificFood2({super.key});

  @override
  State<SpecificFood2> createState() => _SpecificFood2();
}

class _SpecificFood2 extends State<SpecificFood2> {
  int _selectedIndex = -1;
  final List<String> food = [
    'Fish',
    'Beef',
    'Shell fish',
    'Chicken',
    'Turkey',
    'Spicy',
    'Nuts',
    'Milk',
    'Egg',
    'Gluten',
    'Beans',
    'Citric'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Are there any sprcific\nfood to avoid?',
              style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 410,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              // Adjust padding as needed
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 16, // Horizontal space between items
                mainAxisSpacing: 16, // Vertical space between items
                childAspectRatio: 1, // Aspect ratio of the children
              ),
              itemCount: 12,
              // Total number of items
              itemBuilder: (context, index) {
                // Assuming you have a list of texts and images
                String text = food[index];
                String image = 'food${index + 1}.png';

                return _buildContainer(index, text, image);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(int index, String text, String image) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
      },
      child: Container(
        height: 70, // Set your desired height
        width: 70, // Set your desired width
        decoration: BoxDecoration(
            color: isSelected ? Color(0xFFEDC0B2) : Colors.transparent,
            border: Border.all(color: Color(0xFFEDC0B2)),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$image',
            ), // Add your image path here
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Aeonik',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
