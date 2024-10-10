import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../custom_style.dart';
import '../../../providers/app_localizations.dart';
import '../../../services/language_selection.dart';

class SelectedItem extends StatelessWidget {
  final String plan;
  final String price;
  final String image;

  const SelectedItem({
    Key? key,
    required this.plan,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleNotifier>(context).locale;
    bool isRtl = locale?.languageCode == 'ar'; // Check for RTL (Arabic)

    return Container(
      height: 143,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff000000).withOpacity(.07)),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    image,
                    width: 106,
                    height: 106,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 106,
                        height: 106,
                        color: Colors.grey[200],
                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 106,
                            height: 106,
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('planName'), // Use localization
                    style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 12),
                  ),
                  Text(
                    plan,
                    style: CustomTextStyles.labelTextStyle.copyWith(letterSpacing: -.16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    localizations.translate('price'), // Use localization
                    style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 12),
                  ),
                  Text(
                    '$price ${localizations.translate('currency')}',
                    style: CustomTextStyles.labelTextStyle.copyWith(letterSpacing: -.16),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 143,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xff124734),
                borderRadius: isRtl
                    ? const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  topLeft: Radius.circular(28),
                )
                    : const BorderRadius.only(
                  bottomRight: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  localizations.translate('viewPlan'), // Use localization
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Aeonik',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
