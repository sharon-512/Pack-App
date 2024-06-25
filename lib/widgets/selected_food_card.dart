import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedFoodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Color(0xffEDC0B2))
      ),
      child: Row(
        children: [
          SizedBox(width: 10,),
          Image.asset(
            'assets/images/foodcard1.png', // Placeholder for spaghetti image
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Spaghetti',
                          style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 20)
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 30,
                        width: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff124734),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Breakfast',
                          style: CustomTextStyles.titleTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/fire.svg'),
                      Text('210 kcal • 150 g',
                        style: CustomTextStyles.subtitleTextStyle.copyWith(
                            fontSize: 12
                        ),),
                    ],
                  ),
                  Row(
                    children: [
                      NutritionBar(color: const Color(0xffBBC392), label: '21g', widthFactor: 25, label2: ' Protin',), // Adjust the widthFactor as needed
                      NutritionBar(color: const Color(0xffF7C648), label: '29g', widthFactor: 35, label2: ' Carbs',), // Adjust the widthFactor as needed
                      NutritionBar(color: const Color(0xffA8353A), label: '12g', widthFactor: 20, label2: ' Fat',), // Adjust the widthFactor as needed
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionBar extends StatelessWidget {
  final Color color;
  final String label;
  final String label2;
  final double widthFactor; // Added to control the width of the bar

  NutritionBar({
    required this.color,
    required this.label,
    required this.widthFactor, required this.label2, // Width factor parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Aeonik',
                fontWeight: FontWeight.w400,
                fontSize: 10.0,
              ),
              children: <TextSpan>[
                TextSpan(text: label),
                TextSpan(text: label2, style: TextStyle(color: Color(0xffA5A5A5))),
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
                  color: Color(0xffD9D9D9),
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
