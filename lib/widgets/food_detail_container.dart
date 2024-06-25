import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodInfoCard extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const FoodInfoCard({
    super.key,
    required this.isSelected,
    required this.onTap,
  });
  @override
  State<FoodInfoCard> createState() => _FoodInfoCardState();
}

class _FoodInfoCardState extends State<FoodInfoCard> {
  @override
  Widget build(BuildContext context) {
    // Define the color based on the selection state
    Color textColor = widget.isSelected ? Color(0xff54423C) : Colors.black;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        height: 115,
        decoration: BoxDecoration(
          color: widget.isSelected ? Color(0xffEDC0B2) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Color(0xffEDC0B2)),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Image.asset(
              'assets/images/foodcard1.png',
              width: 100,
              height: 100,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 16, 0, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Spaghetti',
                      style: CustomTextStyles.labelTextStyle.copyWith(
                        fontSize: 20,
                        color: textColor, // Apply the conditional color here
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/fire.svg'),
                        Text(
                          '210 kcal • 150 g',
                          style: CustomTextStyles.subtitleTextStyle.copyWith(
                            fontSize: 12,
                            color: textColor, // Apply the conditional color here
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        NutritionBar(
                          color: const Color(0xffBBC392),
                          label: '21g',
                          widthFactor: 25,
                          label2: ' Protin',
                          isSelected: widget.isSelected, // Pass the conditional color to NutritionBar
                        ),
                        NutritionBar(
                          color: const Color(0xffF7C648),
                          label: '29g',
                          widthFactor: 35,
                          label2: ' Carbs',
                          isSelected: widget.isSelected, // Pass the conditional color to NutritionBar
                        ),
                        NutritionBar(
                          color: const Color(0xffA8353A),
                          label: '12g',
                          widthFactor: 20,
                          label2: ' Fat',
                          isSelected: widget.isSelected, // Pass the conditional color to NutritionBar
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class NutritionBar extends StatelessWidget {
  final Color color;
  final String label;
  final String label2;
  final double widthFactor;
  final bool isSelected; // Use a boolean to indicate selection

  NutritionBar({
    required this.color,
    required this.label,
    required this.widthFactor,
    required this.label2,
    required this.isSelected, // Pass isSelected instead of textColor
  });

  @override
  Widget build(BuildContext context) {
    // Determine the text color based on the selection state
    Color textColor = isSelected ? Color(0xff54423C) : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: textColor, // Apply the conditional color here
                fontFamily: 'Aeonik',
                fontWeight: FontWeight.w400,
                fontSize: 10.0,
              ),
              children: <TextSpan>[
                TextSpan(text: label),
                TextSpan(
                  text: label2,
                  style: TextStyle(color: isSelected ?Color(0xff54423C) :Color(0xffA5A5A5)),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected ?Colors.white :Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 4,
                width: widthFactor,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

