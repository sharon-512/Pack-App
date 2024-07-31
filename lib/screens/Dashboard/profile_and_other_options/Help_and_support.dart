import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';


class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GreenAppBar(showBackButton: true, titleText: 'Help and Support'),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to The Plus Pack Ltd Help & Support page. We\'re here to assist you with any questions, concerns, or issues you may have.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Contact Us',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'If you need assistance or have any inquiries, please feel free to contact our customer support team at:\n\n'
                          'Email: support@thepluspack.com\nPhone: +974 3061 6119\n\n'
                          'Our team is available [days of the week] from [hours of operation] to provide you with prompt assistance.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Frequently Asked Questions (FAQs)',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'Browse our FAQs for answers to common questions about our diet food products, services, ordering process, and more. '
                          'If you don\'t find what you\'re looking for, don\'t hesitate to reach out to us directly.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Feedback',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'We value your feedback! Let us know about your experience with The Plus Pack Ltd. Your input helps us improve our products and services to better serve you.',
                      style: CustomTextStyles.informationText,
                    ),
                    const SizedBox(height: 8,),
                    Text('Terms & Conditions',
                      style: CustomTextStyles.informationText.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'For information about our terms of service, please refer to our Terms & Conditions page.',
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