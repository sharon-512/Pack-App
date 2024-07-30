import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../custom_style.dart';
import '../../../Mealselection/meal_selection.dart';


Widget BookYourDailyNutrition(BuildContext context) {
  return Container(
    height: 165,
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MealSelection(
                planId: 1,
              )),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffFEC66F),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/images/selected_pack_bg2.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/phone.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Your\nDaily Nutrition\nThrough',
                  style: CustomTextStyles.titleTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pack App',
                  style: CustomTextStyles.titleTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff124734),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 23,
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xff124734),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Buy Now',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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