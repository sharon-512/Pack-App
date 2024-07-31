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
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last updated: 28/07/2024\n\n'
                          'Welcome to PackUp Kitchen! These terms and conditions outline the rules and regulations for the use of our website and services. By accessing this website and using our services, you accept these terms and conditions in full. If you do not agree with these terms and conditions, please do not use our website or services.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '1. Introduction\n\n'
                          'These Terms and Conditions ("Terms", "Terms and Conditions") govern your relationship with PackUp Kitchen ("us", "we", or "our") and your use of our website [your website URL] (the "Service").\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '2. Accounts\n\n'
                          'When you create an account with us, you must provide accurate, complete, and current information at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.\n\n'
                          'You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service.\n\n'
                          'You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '3. Orders and Payments\n\n'
                          'All orders placed through our website are subject to acceptance and availability. We reserve the right to refuse or cancel any order for any reason, including but not limited to product availability, errors in the description or price of the product, or errors in your order.\n\n'
                          'We accept payments through [list of accepted payment methods]. By placing an order, you agree to pay the full amount for the products purchased, including any applicable taxes and shipping fees.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '4. Shipping and Delivery\n\n'
                          'We will make every effort to deliver your order within the estimated delivery time; however, delivery times are not guaranteed. We are not responsible for any delays in delivery due to circumstances beyond our control.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '5. Returns and Refunds\n\n'
                          'If you are not satisfied with your purchase, you may return the product within [number] days of receipt for a full refund, provided that the product is in its original condition and packaging. To initiate a return, please contact our customer service at [customer service email].\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '6. Intellectual Property\n\n'
                          'The Service and its original content, features, and functionality are and will remain the exclusive property of PackUp Kitchen and its licensors. The Service is protected by copyright, trademark, and other laws of both the United States and foreign countries. Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of PackUp Kitchen.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '7. Limitation of Liability\n\n'
                          'In no event shall PackUp Kitchen, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your use or inability to use the Service; (ii) any unauthorized access to or use of our servers and/or any personal information stored therein; (iii) any interruption or cessation of transmission to or from the Service; (iv) any bugs, viruses, trojan horses, or the like that may be transmitted to or through our Service by any third party; and/or (v) any errors or omissions in any content or for any loss or damage incurred as a result of the use of any content posted, emailed, transmitted, or otherwise made available through the Service, whether based on warranty, contract, tort (including negligence), or any other legal theory, whether or not we have been informed of the possibility of such damage.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '8. Governing Law\n\n'
                          'These Terms shall be governed and construed in accordance with the laws of [State/Country], without regard to its conflict of law provisions.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '9. Changes to These Terms\n\n'
                          'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least [number] days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n\n'
                          'By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the Service.\n\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '5. Contact Us\n\n'
                          'If you have any questions about these Terms, please contact us at info@packqtr.com.\n\n',
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
