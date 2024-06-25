import 'package:flutter/material.dart';
import 'package:pack_app/screens/onboarding/slide_effect/main_page.dart';
import 'package:pack_app/widgets/common_textfield.dart';

import '../../custom_style.dart';
import '../../widgets/common_button.dart';

class EnterDetails extends StatelessWidget {
  const EnterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController();
    final TextEditingController lastName = TextEditingController();
    final TextEditingController email = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Enter your details',
                  style: CustomTextStyles.titleTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  'First Name',
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CommonTextField(
                        hintText: 'Enter your first name', controller: name),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Last Name',
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CommonTextField(
                        hintText: 'Enter your last name', controller: lastName),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Email',
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CommonTextField(
                        hintText: 'Enter your email', controller: email),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
            CommonButton(
              text: 'Continue',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
