import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../custom_style.dart';
import 'Summary/map.dart';
import 'add_address.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}
String _selectedAddress = 'Marina Twin Tower, Lusail';

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController code = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          const GreenAppBar(showBackButton: true, titleText: 'Checkout'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Address',
                        style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff000000).withOpacity(.07)),
                            borderRadius: BorderRadius.circular(17)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded),
                                  SizedBox(width: 8),
                                  Text(
                                    _selectedAddress,
                                    style: CustomTextStyles.titleTextStyle.copyWith(
                                        fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_drop_down_rounded, size: 28),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapSelectionScreen(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _selectedAddress = result['address'];
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Color(0xff124734),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Add new address',
                              style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff124734)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Payment Method',
                        style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff000000).withOpacity(.07)),
                            borderRadius: BorderRadius.circular(17)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/images/card-tick.svg'),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Debit card ending ***808',
                                    style: CustomTextStyles.titleTextStyle.copyWith(
                                        fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 28,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Color(0xff124734),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Add card details',
                            style: CustomTextStyles.titleTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff124734)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Add delivery notes',
                        style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: TextField(
                          controller: code,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Set the radius here
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff000000)
                                      .withOpacity(.07)), // Active border color
                              borderRadius:
                                  BorderRadius.circular(8.0), // Set the radius here
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff000000)
                                      .withOpacity(.07)), // Normal border color
                              borderRadius:
                                  BorderRadius.circular(8.0), // Set the radius here
                            ),
                            hintText: 'Add note here...',
                            hintStyle: CustomTextStyles.hintTextStyle,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 158,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff000000).withOpacity(.07)),
                            borderRadius: BorderRadius.circular(28)),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub total',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '3100 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '200 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '100 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Color(0xff000000).withOpacity(.09),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub total',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '3100 QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  CommonButton(
                    text: 'Check Out',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAddress(),
                          ));
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
