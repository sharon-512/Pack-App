
import 'package:flutter/material.dart';

import '../../../custom_style.dart';

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