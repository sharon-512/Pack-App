import 'package:flutter/material.dart';
import 'package:pack_app/screens/check_out.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../custom_style.dart';


class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController code = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'Summary'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SelectedItem('Weight loss seekers', '3000 QR'),
                      const SizedBox(
                        height: 15,
                      ),
                      Addon('Spindrift Lemon', '100 QR'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: code,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the radius here
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff000000).withOpacity(.07)),
                                  // Active border color
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the radius here
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff000000).withOpacity(.07)),
                                  // Normal border color
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the radius here
                                ),
                                hintText: 'Enter promo code',
                                hintStyle: CustomTextStyles.hintTextStyle,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                // Your onPressed function here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                // Background color as black
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15), // Radius as 15
                                ),
                              ),
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    color: Colors.white), // Text color as white
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 158,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff000000).withOpacity(.07)),
                            borderRadius: BorderRadius.circular(28)),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Weight loss seekers',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '3000 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add ons',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '100 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Color(0xff000000).withOpacity(.09),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub total',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '3100 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  CommonButton(
                    text: 'Check Out',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckOutScreen(),
                          ));
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SelectedItem(String plan, String price) {
    return Container(
      height: 143,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff000000).withOpacity(.07)),
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/foodcard1.png',
                // Placeholder for spaghetti image
                width: 106,
                height: 106,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan name',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    plan,
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -.16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Price',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    price,
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -.16),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 143,
            width: 50,
            decoration: const BoxDecoration(
                color: Color(0xff124734),
                //border: Border.all(color: ),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(28),
                    topRight: Radius.circular(28))),
            alignment: Alignment.center,
            child: const RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'View Plan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Aeonik'),
                )),
          )
        ],
      ),
    );
  }

  Widget Addon(String plan, String price) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color(0xff000000).withOpacity(.07), width: 1),
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/addon.png', // Placeholder for spaghetti image
                width: 106,
                height: 106,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan name',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    plan,
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -.16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Price',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    price,
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -.16),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 143,
            width: 50,
            decoration: BoxDecoration(
                color: Color(0xff124734),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(28),
                    topRight: Radius.circular(28))),
            alignment: Alignment.center,
            child: const RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'View',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Aeonik'),
                )),
          )
        ],
      ),
    );
  }
}
