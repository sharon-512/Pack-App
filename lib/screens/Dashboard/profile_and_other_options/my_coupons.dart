import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../custom_style.dart';
import '../Home_page/widget/selected_pack_card.dart';

class MyCoupons extends StatelessWidget {
  const MyCoupons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'My Coupons'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                coupenCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget coupenCard () {
    return Container(
      height: 155,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/coupons2.png',height: 120,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Welcome offer\n50% off for all\nPackages',
                      style: CustomTextStyles.titleTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff124734),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'WELCOME',
                            style: CustomTextStyles.titleTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Icon(Icons.file_copy_rounded,size: 16,color: Colors.grey[300],)
                        ],
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
