import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';


class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'Privacy Policy'),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'At The Plus Pack Ltd, we are committed to protecting the privacy and security of your personal information. '
                          'This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you use our website, mobile app, or interact with us in any way.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Information We Collect',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We may collect personal information from you when you visit our website, place an order, sign up for our loyalty program, or participate in surveys or promotions. '
                          'This information may include your name, email address, phone number, shipping address, dietary preferences, payment details, and other relevant information.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('How We Use Your Information',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We use the information we collect to process your orders, improve our products and services, personalize your experience, and communicate with you about promotions, offers, and updates. We may also use your information to respond to your inquiries and provide customer support.Data Security\n\n'
                          'We take the security of your information seriously and implement appropriate measures to protect it from unauthorized access, disclosure, alteration, or destruction. We use industry-standard encryption and security protocols to safeguard your data',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Third-Party Services',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We may share your information with trusted third-party service providers who assist us in operating our business, such as payment processors, shipping companies, and marketing partners. '
                          'These third parties are contractually obligated to protect your information and are only authorized to use it to perform services on our behalf.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Your Rights',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'You have the right to access, correct, or delete your personal information at any time. You may also choose to opt out of receiving marketing communications from us. '
                          'Additionally, you can manage your cookie preferences through your browser settings.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Changes to This Policy',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We reserve the right to update this Privacy Policy periodically to reflect changes in our practices and legal requirements. We will notify you of any material changes by posting the updated policy on our website or through other appropriate channels.'
                          'If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at privacy@thepluspack.com.',
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


