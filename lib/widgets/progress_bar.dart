import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';

import '../providers/app_localizations.dart';

class StaticProgressBar extends StatelessWidget {
  final double progress;
  final int value;

  StaticProgressBar({required this.progress, required this.value});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations!.translate('youAreAlmostThere'),
                style: CustomTextStyles.subtitleTextStyle.copyWith(color: Colors.black),),
              Text('$value/5',
                style: CustomTextStyles.subtitleTextStyle,),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xffFFF2E1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFEC66F)),
              minHeight: 10,
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
