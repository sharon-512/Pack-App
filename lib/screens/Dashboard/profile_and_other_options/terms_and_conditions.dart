import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';


class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GreenAppBar(showBackButton: true, titleText: 'Terms & Conditions'),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to The Plus Pack Ltd. These Terms & Conditions govern your use of our website, mobile app, and services. '
                          'By accessing or using our platform, you agree to comply with these terms. Please read them carefully.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 16,),
                    Text('1. Use of Our Platform\n\n'
                        '1.1 You must be at least 18 years old to use our platform.\n\n'
                        '1.2 You agree to provide accurate and complete information when using our services.\n\n'
                        '1.3 You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\n'
                        '2. Ordering & Payments\n\n'
                        '2.1 When placing an order, you agree to pay the listed price for the products or services selected.\n\n'
                        '2.2 Payments must be made using valid payment methods accepted by Go Crispy Chicken Company.\n\n'
                        '2.3 All prices listed on our platform are in the local currency and are inclusive of applicable taxes and fees.\n\n'
                        '3. Delivery & Returns\n\n'
                        '3.1 We aim to deliver orders promptly and within the estimated delivery timeframe provided.\n\n'
                        '3.2 If you are not satisfied with your order, please contact us within [number] days for assistance with returns or refunds.\n\n'
                        '3.3 We reserve the right to refuse or cancel orders in the event of inaccuracies, errors, or fraud.\n\n'
                        '4. Intellectual Property\n\n'
                        '4.1 All content on our platform, including text, graphics, logos, images, and software, is the property of Go Crispy Chicken Company and is protected by intellectual property laws.\n\n'
                        '4.2 You may not use, reproduce, distribute, or modify any content from our platform without prior written consent.\n\n'
                        '5. Limitation of Liability\n\n'
                        '5.1 Go Crispy Chicken Company shall not be liable for any direct, indirect, incidental, special, or consequential damages arising from your use of our platform or products/services.\n\n'
                        '5.2 Our liability is limited to the fullest extent permitted by law.\n\n'
                        '6. Governing Law\n\n'
                        '6.1 These Terms & Conditions shall be governed by and construed in accordance with the laws of [Jurisdiction], without regard to its conflict of law provisions.\n\n'
                        '7. Changes to Terms & Conditions\n\n'
                        '7.1 We reserve the right to update or modify these Terms & Conditions at any time without prior notice. By continuing to use our platform after such changes, you agree to be bound by the revised terms.\n\n'
                        '8. Contact Us\n\n'
                        '8.1 If you have any questions or concerns about these Terms & Conditions, please contact us at support@gocrispychicken.com.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 18,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




