import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/screens/onboarding/start_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
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
            SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/tick3.png'),
            const Text(
              'Payment Completed',
              style: TextStyle(
                  fontFamily: 'Aeonik',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.41),
            ),
            SizedBox(
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
                            const Text(
                              '3100 QR',
                              style: TextStyle(
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w700,
                                fontSize: 34,
                              ),
                            ),
                            const Text(
                              '7 April 2024 . 10:40 am',
                              style: TextStyle(
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
                                    'Customer ID',
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
                                    'Delivery Date',
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
                                    'Weight loss seeker',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'P000432',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    '889767',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Sheharin',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    '10 April 2024',
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
                            color: Color(0xffFBC56D),
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
            SizedBox(
              height: 60,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartScreen(),
                      ));
                },
                child: SvgPicture.asset('assets/images/exit.svg')),
          ],
        ),
      ),
    );
  }
}
