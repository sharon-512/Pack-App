import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../custom_style.dart';
import 'check_out.dart';

// Model class for menu item
class MenuItem {
  final int menuId;
  final String menuName;
  final String menuImage;

  MenuItem({
    required this.menuId,
    required this.menuName,
    required this.menuImage,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuId: json['menu_id'],
      menuName: json['menu_name'] ?? 'Unknown',
      menuImage: json['menu_image'] ?? '',
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final int selectedBreakfastMenuId;
  final int selectedLunchMenuId;
  final int selectedSnacksMenuId;
  final int selectedDinnerMenuId;

  const SummaryScreen({
    Key? key,
    required this.selectedBreakfastMenuId,
    required this.selectedLunchMenuId,
    required this.selectedSnacksMenuId,
    required this.selectedDinnerMenuId,
  }) : super(key: key);

  Future<MenuItem> fetchMenuItem(int menuId, String mealType) async {
    final response = await http
        .get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var mealPlans = data['plan'][0]['sub_plans'][0]['meal_plan'];

      for (var mealPlan in mealPlans) {
        if (mealPlan['products'].containsKey(mealType)) {
          var products = mealPlan['products'][mealType] as List;
          var menuItemJson = products.firstWhere(
              (item) => item['menu_id'] == menuId,
              orElse: () => null);
          if (menuItemJson != null) {
            return MenuItem.fromJson(menuItemJson);
          }
        }
      }
      throw Exception('Menu item not found');
    } else {
      throw Exception('Failed to load menu item');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController code = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GreenAppBar(showBackButton: true, titleText: 'Summary'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          FutureBuilder<MenuItem>(
                            future: fetchMenuItem(
                                selectedBreakfastMenuId, 'BreakFast'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              } else {
                                final menuItem = snapshot.data!;
                                return SelectedItem(
                                  plan: menuItem.menuName,
                                  price:
                                      '${menuItem.menuName}', // Adjust this as needed
                                  imageUrl: menuItem.menuImage,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          FutureBuilder<MenuItem>(
                            future: fetchMenuItem(selectedLunchMenuId, 'Lunch'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              } else {
                                final menuItem = snapshot.data!;
                                return SelectedItem(
                                  plan: menuItem.menuName,
                                  price:
                                      '${menuItem.menuName}', // Adjust this as needed
                                  imageUrl: menuItem.menuImage,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          FutureBuilder<MenuItem>(
                            future:
                                fetchMenuItem(selectedSnacksMenuId, 'Snacks'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }  else if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              } else {
                                final menuItem = snapshot.data!;
                                return SelectedItem(
                                  plan: menuItem.menuName,
                                  price:
                                      '${menuItem.menuName}', // Adjust this as needed
                                  imageUrl: menuItem.menuImage,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          FutureBuilder<MenuItem>(
                            future:
                                fetchMenuItem(selectedDinnerMenuId, 'Dinner'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              } else {
                                final menuItem = snapshot.data!;
                                return SelectedItem(
                                  plan: menuItem.menuName,
                                  price:
                                      '${menuItem.menuName}', // Adjust this as needed
                                  imageUrl: menuItem.menuImage,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      // Other widgets like the promo code input and the total summary
                      Column(
                        children: [
                          Addon('Spindrift Lemon', '100 QR'),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: code,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Set the radius here
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff000000)
                                              .withOpacity(.07)),
                                      // Active border color
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Set the radius here
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff000000)
                                              .withOpacity(.07)),
                                      // Normal border color
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Set the radius here
                                    ),
                                    hintText: 'Enter promo code',
                                    hintStyle: CustomTextStyles.hintTextStyle,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Your onPressed function here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    // Background color as black
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // Radius as 15
                                    ),
                                  ),
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(
                                        color: Colors
                                            .white), // Text color as white
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 158,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff000000).withOpacity(.07)),
                                borderRadius: BorderRadius.circular(28)),
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Weight loss seekers',
                                        style: CustomTextStyles.hintTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        '3000 QR',
                                        style: CustomTextStyles.hintTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add ons',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                      SizedBox(height: 80), // Space for the "Check Out" button
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CommonButton(
              text: 'Check Out',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckOutScreen(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget SelectedItem(
      {required String plan, required String price, required String imageUrl}) {
    return Container(
      height: 143,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff000000).withOpacity(.07)),
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: 106,
                height: 106,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
              SizedBox(
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
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: CustomTextStyles.labelTextStyle
                        .copyWith(letterSpacing: -0.16, fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Price',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Flexible(
                    child: Text(
                      price,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: CustomTextStyles.labelTextStyle.copyWith(
                        letterSpacing: -0.16,
                        fontSize: 14, // Adjust font size if necessary
                      ),
                    ),
                  ),
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
                  'View Plan',
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

  Widget Addon(String plan, String price) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color(0xff000000).withOpacity(.07), width: 1),
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/addon.png', // Placeholder for spaghetti image
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Price',
                    style: CustomTextStyles.subtitleTextStyle
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    price,
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
            decoration: BoxDecoration(
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
