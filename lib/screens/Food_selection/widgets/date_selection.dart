import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_container.dart';


class DateSelection extends StatelessWidget {
  final int selectedDay;
  final List<Map<String, dynamic>> dailySelections;
  final Function(int) onDateSelected;

  const DateSelection({
    Key? key,
    required this.selectedDay,
    required this.dailySelections,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: () => onDateSelected(index),
            child: Row(
              children: [
                CustomContainer(
                  isSelected: index == selectedDay,
                  text1: text1,
                  text2: text2,
                  text3: text3,
                ),
                SizedBox(width: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
