import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/common_button.dart';
import 'enter_number.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // This line exits the app.
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFF7EE),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/payment_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      child: Image.asset('assets/images/start_image.png'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff2F2D28).withOpacity(0.60),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 130, 10, 26),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w700,
                                fontSize: 62.0,
                                height: 60.0 / 64.0,
                                // Line height divided by font size to get the height multiplier
                                letterSpacing: -0.41,
                              ), // Default text style
                              children: <TextSpan>[
                                TextSpan(text: 'Your Gateway\nto '),
                                TextSpan(
                                    text: 'Healthier\n',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic)),
                                TextSpan(text: 'Living!'),
                              ],
                            ),
                          ),
                          const Text(
                            'Pack App: Where Healthy Eating Meets Convenience!',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Aeonik',
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CommonButton(
                      text: 'Get Started',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EnterNumber(),
                            ));
                      },
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Aeonik',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'EN',
                            style: TextStyle(color: Color(0xFF124734))),
                        TextSpan(
                            text: ' | ',
                            style: TextStyle(color: Color(0xFFBEBEBE))),
                        TextSpan(
                            text: 'AR',
                            style: TextStyle(color: Color(0xFFBEBEBE))),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
