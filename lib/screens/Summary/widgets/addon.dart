import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_style.dart';
import '../../../providers/app_localizations.dart';
import '../../../services/language_selection.dart';

class Addon extends StatelessWidget {
  final String plan;
  final String price;

  const Addon({
    Key? key,
    required this.plan,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleNotifier>(context).locale;

    // Determine border radius for the "View" button based on locale
    BorderRadiusGeometry viewButtonBorderRadius = locale?.languageCode == 'ar'
        ? BorderRadius.only(
      bottomLeft: Radius.circular(28),
      topLeft: Radius.circular(28),
    )
        : BorderRadius.only(
      bottomRight: Radius.circular(28),
      topRight: Radius.circular(28),
    );

    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xff000000).withOpacity(.07),
            width: 1
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/addon.png', // Placeholder for the image
                width: 106,
                height: 106,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan,
                    style: CustomTextStyles.labelTextStyle.copyWith(letterSpacing: -.16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    localizations.translate('price'), // Translated price label
                    style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 12),
                  ),
                  Text(
                    '$price ${localizations.translate('currency')}', // Append QR with localization
                    style: CustomTextStyles.labelTextStyle.copyWith(letterSpacing: -.16),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 143,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xff124734),
              borderRadius: viewButtonBorderRadius,
            ),
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                localizations.translate('view'), // Translated view button text
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Aeonik',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
