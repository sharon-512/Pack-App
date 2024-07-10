import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';

import 'meal_selection.dart';

class PackageSelection extends StatelessWidget {
  const PackageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/profile_pic.png',
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/hand_emoji.png'),
                            Text(
                              'Hello! Mariam',
                              style: CustomTextStyles.labelTextStyle.copyWith(
                                  color: Color(0xffD7D7D7), fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          'Welcome to Pack',
                          style: CustomTextStyles.labelTextStyle
                              .copyWith(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
                Image.asset('assets/images/setting.png'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(
                thickness: 1, // Set the thickness of the divider as needed
                color:
                    Color(0x2abbbbbb), // Set the color of the divider as needed
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Select Your Package',
              style: CustomTextStyles.titleTextStyle.copyWith(
                  color: Color(0xff124734),
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              height: 480,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealSelection(planId: 0,)),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xff104735)),
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                          'assets/images/packsl1.png')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Shredded\nPack',
                                    style: CustomTextStyles.titleTextStyle
                                        .copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealSelection(planId: 0,)),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffEDC0B2)),
                                  alignment: Alignment.topLeft,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                          'assets/images/packsl2.png')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Cheat Pack',
                                    style: CustomTextStyles.titleTextStyle
                                        .copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealSelection(planId: 0,)),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffBAC392)),
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                          'assets/images/packsl3.png')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Maintain\nWeight',
                                    style: CustomTextStyles.titleTextStyle
                                        .copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>MealSelection(planId: 0,)),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffA8353A)),
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                          'assets/images/packsl4.png')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Lose\nWeight',
                                    style: CustomTextStyles.titleTextStyle
                                        .copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealSelection(planId: 0,)),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffFEC66F)),
                                  alignment: Alignment.topLeft,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                          'assets/images/packsl5.png')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Gain Pack',
                                    style: CustomTextStyles.titleTextStyle
                                        .copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
