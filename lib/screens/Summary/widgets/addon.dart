import 'package:flutter/material.dart';

import '../../../custom_style.dart';

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
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border:
          Border.all(color: const Color(0xff000000).withOpacity(.07), width: 1),
          borderRadius: BorderRadius.circular(28)),
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
                    'Plan name',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    plan,
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -.16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Price',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    '$price QR', // Append QR to price
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -.16),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 143,
            width: 50,
            decoration: const BoxDecoration(
                color: Color(0xff124734),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(28),
                    topRight: Radius.circular(28))),
            alignment: Alignment.center,
            child: const RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'View',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Aeonik'),
                )),
          )
        ],
      ),
    );
  }
}
