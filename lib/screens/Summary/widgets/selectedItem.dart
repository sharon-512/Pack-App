import 'package:flutter/material.dart';

import '../../../custom_style.dart';

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
    return Container(
      height: 143,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff000000).withOpacity(.07)),
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                image, // Placeholder for the image
                width: 106,
                height: 106,
              ),
              const SizedBox(
                width: 10,
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
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
                    'View Plan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Aeonik'),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
