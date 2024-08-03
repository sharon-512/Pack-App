import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../custom_style.dart';
import '../../../Mealselection/meal_selection.dart';
import '../../nav_bar.dart';


class EmptyMeal extends StatelessWidget {
  const EmptyMeal ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 165,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0x52fec66f),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/selected_pack_bg2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomRight,
              // child: Padding(
              //   padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(20),
              //     child: Image.asset('assets/images/phone.png'),
              //   ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You haven\'t ordered any food yet',
                    //'Book Your Daily Nutrition\nThrough',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Book Your Daily Nutrition Through\nPack App',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff124734),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavbar()),
                      );
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff124734),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Order Now',
                        style: CustomTextStyles.titleTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
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
}