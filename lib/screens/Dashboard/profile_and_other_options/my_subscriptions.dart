import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../custom_style.dart';
import '../Home_page/widget/selected_pack_card.dart';

class MySubscriptions extends StatelessWidget {
  const MySubscriptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'My Subscriptions'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SelectedPackCard(planName: 'Lose Weight', planDuration: '3 Week Plan'),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 92, // Height set to 92
                        decoration: BoxDecoration(
                          color: Color(0xFF124734), // Background color for the 1st container
                          borderRadius: BorderRadius.circular(10), // Radius of 10 pixels
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/note.png'),
                              SizedBox(height: 5),
                              Text(
                                'Plan Start',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Apr 21',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: Container(
                        height: 92, // Height set to 92
                        decoration: BoxDecoration(
                          color: Color(0xFFBBC392), // Background color for the 2nd container
                          borderRadius: BorderRadius.circular(10), // Radius of 10 pixels
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/note.png', color: Color(0xff8D9858),),
                              SizedBox(height: 5),
                              Text(
                                'Plan ends',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'May 19',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: Container(
                        height: 92, // Height set to 92
                        decoration: BoxDecoration(
                          color: Color(0xFFA8353A), // Background color for the 3rd container
                          borderRadius: BorderRadius.circular(10), // Radius of 10 pixels
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/timer.png'),
                              SizedBox(height: 5),
                              Text(
                                'Remainig',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '28 days',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
