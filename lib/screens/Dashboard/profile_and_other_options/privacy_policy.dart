import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../providers/app_localizations.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: localizations!.translate('privacyPolicy'),),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last updated: 28/07/2028',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'Welcome to PackUp Kitchen! We value your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website [your website URL] and use our services. Please read this Privacy Policy carefully. If you do not agree with the terms of this Privacy Policy, please do not access the site or use our services.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '1. Information We Collect',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We may collect and process the following data about you:',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '• Personal Identification Information: Name, email address, phone number, address, and other contact details.\n'
                          '• Order Information: Details about orders you place through our website, including payment information.\n'
                          '• Technical Data: IP address, browser type, version, time zone setting, browser plug-in types, operating system, and platform.\n'
                          '• Usage Data: Information about how you use our website and services.\n'
                          '• Marketing and Communications Data: Your preferences in receiving marketing from us and your communication preferences.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '2. How We Use Your Information',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We use the information we collect in the following ways:',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '• To provide and maintain our services.\n'
                          '• To process your orders and manage your account.\n'
                          '• To improve our website and services.\n'
                          '• To communicate with you, including sending marketing and promotional materials.\n'
                          '• To comply with legal obligations and protect our rights.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '3. Sharing Your Information',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We may share your information with:',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '• Service Providers: We may share your information with third-party service providers who perform services on our behalf.\n'
                          '• Business Transfers: In connection with any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.\n'
                          '• Legal Requirements: If required by law, to comply with legal processes, or to protect the rights, property, or safety of our company, our customers, or others.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '4. Security of Your Information',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We use administrative, technical, and physical security measures to help protect your personal information. However, no method of transmission over the Internet, or method of electronic storage is 100% secure, and we cannot guarantee its absolute security.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '5. Your Data Protection Rights',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'Depending on your location, you may have the following rights regarding your personal data:',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      '• The right to access – You have the right to request copies of your personal data.\n'
                          '• The right to rectification – You have the right to request that we correct any information you believe is inaccurate.\n'
                          '• The right to erasure – You have the right to request that we erase your personal data, under certain conditions.\n'
                          '• The right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions.\n'
                          '• The right to object to processing',
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
