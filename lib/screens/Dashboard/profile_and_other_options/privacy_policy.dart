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
                      'Welcome to PackUp Kitchen! We value your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website [your website URL] and use our services. Please read this Privacy Policy carefully. If you do not agree with the terms of this Privacy Policy, please do not access the site or use our services.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('1. Information We Collect',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '•	Personal Identification Information: Name, email address, phone number, address, and other contact details.\n'
                      '•	Order Information: Details about orders you place through our website, including payment information.\n'
                      '•	Technical Data: IP address, browser type, version, time zone setting, browser plug-in types, operating system, and platform.\n'
                      '•	Usage Data: Information about how you use our website and services.\n'
                      '•	Marketing and Communications Data: Your preferences in receiving marketing from us and your communication preferences.\n',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('How We Use Your Information',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We use the information we collect in the following ways:\n'
                    '•	To provide and maintain our services.\n'
                    '•	To process your orders and manage your account.\n'
                    '•	To improve our website and services.\n'
                    '•	To communicate with you, including sending marketing and promotional materials.\n'
                    '•	To comply with legal obligations and protect our rights.\n',
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


