import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../custom_style.dart';
import '../../../../providers/app_localizations.dart';
import '../../../../services/language_selection.dart';

class SelectedPackCard extends StatelessWidget {
  final String planName;
  final String planDuration;

  const SelectedPackCard(
      {super.key, required this.planName, required this.planDuration});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleNotifier>(context).locale;
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffFFF2E1),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/images/selected_pack_bg2.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topRight,
            child: locale?.languageCode != 'ar'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/selected_pack_1.png'),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 28,
                  width: 98,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffFEC66F),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    planDuration,
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations!.translate('yourPlan'),
                      style: CustomTextStyles.titleTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      planName,
                      style: CustomTextStyles.titleTextStyle.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffA8353A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
