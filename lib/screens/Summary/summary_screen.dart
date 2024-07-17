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
    required this.selectedAddons, // Add this line
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
                          plan: widget.planName, price: widget.foodPrice),
                      const SizedBox(
                        height: 15,
                      ),
                      Addon(plan: widget.planName, price: '$addonPrice',),
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
                    onTap: _placeOrder, // Call the _placeOrder method here
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

  void _placeOrder() async {
    try {
      String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiYjRkMDY2OTFlZjA5NTAyOGZmMDBlODUxNTQ0YjExNjIwZjk3YmZhNTdjNjdiYmQ2NjgyNmZhZmFhMTBjMTY1ZjVkYjA1OWQ3YThiMzIzMGUiLCJpYXQiOjE3MjA4NzkwOTkuMDAyMjQwODk2MjI0OTc1NTg1OTM3NSwibmJmIjoxNzIwODc5MDk5LjAwMjI0MzA0MTk5MjE4NzUsImV4cCI6MTc1MjQxNTA5OS4wMDAzODY5NTMzNTM4ODE4MzU5Mzc1LCJzdWIiOiIxOSIsInNjb3BlcyI6W119.SvasUJyXmh_3d3YfXIWO-QYHZZdfPWUX4CqVogft9SFwZXPqKlCBloz-z-x-2AJq1bhXvvK_owJWaEHKgiEVd3vWc8wI1XcCYkKAn2U2Q81LcPgRn-jjviANCa7pHIu3sbGYbAHz5b_zU6O92mzKXo7cvrEBwXqaJWFcb7p-ekrdrnsKDP8Ox6yWg_AjdOjwj8Q3-yVfWBBqZxhPizeeAJK6q-VTIm8uOLiIhqHHE4rwXQx6Np99aXEV-oYujOYl0Vl4IpsvnkYqFBBbPghPPhUThahXPmJTTlfMMy_NuglCOj9QHW--KnAarNMZFw1PHZCWRQJBCK3SzFfrn6h_XnP3-d9fiSVmBuvvWpBmrBG9bg_NFcyjwk3lcaer5C0d5ES10iKj3R029MBaGJ96PFc4NIGh8N4x0glzdQSYdzbWFvLBCEbX5ru9RtN95-BOY52Sr33mQf6zSLb0Lc4L7rIglvLjIm_IasT6LvRdJdqOyj-ZdF_Z-9h-kJAm8O8A8L8jUz6_2uRGneuqzasIXWThZFAgNUeyvYQ2JjwZN0tBv5ffz-UB8ud-o_fj8mO0iApCOfAhA1xHqqh7GPnbX-KEWWrfWzum9xGJ4Qi8_c8KUlAnPjdn5PV1zey_rlGXqnPPGQ_zzEbr2QfQIfZWrJsiAfQDsd4w4eJRbKW_R28';

      var result = await ApiService.placeOrder(
        token: token,
        startDate: startDate,
        endDate: endDate,
        productId: widget.planId.toString(),
        dailySelections: widget.dailySelections,
        selectedAddons: widget.selectedAddons,
      );

      if (result['success']) {
        print('Order saved successfully.');
        print('Response: ${result['data']}');
        // Navigate to CheckoutScreen or handle success as needed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckOutScreen(),
          ),
        );
      } else {
        print('Failed to save order. Error: ${result['error']}');
        // Handle error scenario
      }
    } catch (e) {
      print('Error placing order: $e');
      // Handle network or other errors
    }
  }
}
