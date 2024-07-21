import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/screens/Dashboard/nav_bar.dart';

import '../models/user_model.dart';

class PaymentScreen extends StatelessWidget {
  final double subTotal;
  final String planName;

  const PaymentScreen({super.key,
    required this.subTotal,
    required this.planName
  });

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');
    final String formattedDate = DateFormat('d MMMM yyyy . hh:mm a').format(DateTime.now());
    final int generatedId = Random().nextInt(10000);  // Generates a random ID between 0 and 9999

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/payment_bg.png'),
            fit: BoxFit.cover,
          ),
          gradient: RadialGradient(
            // The gradient center alignment, adjust as needed
            center: Alignment(0.2698, -0.3198),
            // The radius of the gradient, adjust to fit the screen
            radius: 2,
            colors: [
              Color(0xFF002216), // Dark color
              Color(0xFF124734), // Light color
            ],
            // If you have specific stops, define them here
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/tick3.png'),
            const Text(
              'Order Successful',
              style: TextStyle(
                  fontFamily: 'Aeonik',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.41),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 360,
              width: 310,
              child: Stack(
                children: [
                  Container(
                    height: 360,
                    width: 310,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bill_bg.png'),
                        fit: BoxFit
                            .fill, // Changed to BoxFit.cover to fill the entire container
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Center the column in the stack
                      children: [
                        Column(
                          children: [
                            Text(
                              '${subTotal} QR',
                              style: const TextStyle(
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w700,
                                fontSize: 34,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Color(0xffB6B6B6),
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item name',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Order NO',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Customer Name',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Start Date',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'End Date',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planName,
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    generatedId.toString(),
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    user!.firstname ?? 'name',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    '------',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    '------',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 260,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffFBC56D),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/share.svg'),
                              Text(
                                '  Share Receipt',
                                style: CustomTextStyles.labelTextStyle
                                    .copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavbar(selectedIndex: 0,),
                      ));
                },
                child: SvgPicture.asset('assets/images/exit.svg')),
          ],
        ),
      ),
    );
  }
}
