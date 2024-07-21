import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/screens/Summary/widgets/addon.dart';
import 'package:pack_app/screens/Summary/widgets/selectedItem.dart';
import 'package:pack_app/screens/check_out.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_style.dart';
import '../../services/apiPost.dart';

class SummaryScreen extends StatefulWidget {
  final String foodPrice;
  final String planName;
  final String planImage;
  final int planId;
  final int subplanId;
  final int mealtypeId;
  final double addonPrice;
  final List<Map<String, dynamic>> dailySelections;
  final List<Map<String, dynamic>> selectedAddons; // Add this line

  const SummaryScreen({
    Key? key,
    required this.foodPrice,
    required this.planId,
    required this.subplanId,
    required this.mealtypeId,
    required this.planName,
    required this.addonPrice,
    required this.dailySelections,
    required this.selectedAddons,
    required this.planImage, // Add this line
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<Map<String, dynamic>> dailySelections = [];
  List<Map<String, dynamic>> selectedAddons = [];
  late DateTime startDate;
  late DateTime endDate;
  bool _isLoading = true;
  void addDailySelections(Map<String, dynamic> selection) {
    dailySelections.add(selection);
  }

  @override
  void initState() {
    super.initState();
    fetchDatesFromSharedPreferences();
    dailySelections = widget.dailySelections;
    selectedAddons = widget.selectedAddons;
    print(selectedAddons);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController code = TextEditingController();
    final double foodPrice = double.parse(widget.foodPrice);
    final double addonPrice = widget.addonPrice;
    final double subTotal = foodPrice + addonPrice;

    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'Summary'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SelectedItem(
                        plan: widget.planName,
                        price: widget.foodPrice,
                        image: widget.planImage
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (addonPrice != 0)
                        Addon(
                          plan: 'Addons',
                          price: '$addonPrice',
                        ),
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
                                      color:
                                          Color(0xff000000).withOpacity(.07)),
                                  // Active border color
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the radius here
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color(0xff000000).withOpacity(.07)),
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
                                  borderRadius:
                                      BorderRadius.circular(15), // Radius as 15
                                ),
                              ),
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    color: Colors.white), // Text color as white
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.planName,
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '${widget.foodPrice} QR',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              if (addonPrice != 0)
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
                                      '$addonPrice QR', // Assuming add-ons price is a fixed 100 QR
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
                                    '${subTotal} QR', // Calculate the subtotal
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
                            builder: (context) => CheckOutScreen(
                              dailySelections: widget.dailySelections,
                              selectedAddons: widget.selectedAddons,
                              planId: widget.planId,
                              subTotal: subTotal.toString(),
                              foodPrice: widget.foodPrice,
                              addonPrice: widget.addonPrice,
                              planName: widget.planName,
                            ),
                          ),
                        );
                      } // Call the _placeOrder method here
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchDatesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedStartDate = prefs.getString('startDate');
    final storedEndDate = prefs.getString('endDate');

    if (storedStartDate != null && storedEndDate != null) {
      try {
        setState(() {
          // Parse date strings into DateTime objects
          startDate = DateFormat('EEEE, MMMM d, yyyy').parse(storedStartDate);
          endDate = DateFormat('EEEE, MMMM d, yyyy').parse(storedEndDate);
          _isLoading = false;
        });

        // Format DateTime objects to string in "yyyy-MM-dd" format
        final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
        final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

        // Print the parsed and formatted dates (optional)
        print('Parsed Start Date: $formattedStartDate');
        print('Parsed End Date: $formattedEndDate');
      } catch (e) {
        print('Error parsing dates: $e');
        // Handle the error appropriately, e.g., set default dates
        setState(() {
          startDate = DateTime.now();
          endDate = DateTime.now();
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        startDate = DateTime.now();
        endDate = DateTime.now();
        _isLoading = false;
      });

      // Format DateTime objects to string in "yyyy-MM-dd" format
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      // Print the default dates (optional)
      print('Default Start Date: $formattedStartDate');
      print('Default End Date: $formattedEndDate');
    }
  }
}
