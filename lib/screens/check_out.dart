import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import '../services/apiPost.dart';
import 'Summary/map.dart';
import 'add_address.dart';
import '../custom_style.dart';

class CheckOutScreen extends StatefulWidget {
  final int planId;
  final String subTotal;
  final List<Map<String, dynamic>> dailySelections;
  final List<Map<String, dynamic>> selectedAddons; // Add this line
  const CheckOutScreen(
      {Key? key,
      required this.dailySelections,
      required this.selectedAddons,
      required this.planId, required  this.subTotal})
      : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<String> _addresses = [];
  String? _selectedAddress;
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
    _loadAddresses();
    fetchDatesFromSharedPreferences();
  }

  Future<void> _loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedAddresses = prefs.getStringList('addresses');
    setState(() {
      _addresses = savedAddresses ?? ['Marina Twin Tower, Lusail'];
      _selectedAddress = _addresses.first;
    });
  }

  Future<void> _saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _addresses.add(address);
      _selectedAddress = address;
    });
    await prefs.setStringList('addresses', _addresses);
  }

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
                        style: CustomTextStyles.titleTextStyle
                            .copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xff000000).withOpacity(.07)),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.location_on_rounded),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down_rounded,
                                      size: 28),
                                  value: _selectedAddress,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedAddress = newValue!;
                                    });
                                  },
                                  items: _addresses
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Text(
                                          value,
                                          style: CustomTextStyles.titleTextStyle
                                              .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final result =  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  MapSelectionScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Color(0xff124734),
                            ),
                            SizedBox(width: 8),
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
                      const SizedBox(height: 20),
                      Text(
                        'Payment Method',
                        style: CustomTextStyles.titleTextStyle
                            .copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff000000).withOpacity(.07)),
                            borderRadius: BorderRadius.circular(17)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/card-tick.svg'),
                                  SizedBox(width: 8),
                                  Text(
                                    'Debit card ending ***808',
                                    style: CustomTextStyles.titleTextStyle
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_drop_down_rounded, size: 28),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Color(0xff124734),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add card details',
                            style: CustomTextStyles.titleTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff124734)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add delivery notes',
                        style: CustomTextStyles.titleTextStyle
                            .copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
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
                                      .withOpacity(.07)), // Active border color
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the radius here
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff000000)
                                      .withOpacity(.07)), // Normal border color
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the radius here
                            ),
                            hintText: 'Add note here...',
                            hintStyle: CustomTextStyles.hintTextStyle,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(width: 10),
                      const SizedBox(height: 25),
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
                                    'Sub total',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    widget.subTotal,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  color: Color(0xff000000).withOpacity(.09)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
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
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  CommonButton(
                    text: 'Check Out',
                    onTap: _placeOrder
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
            builder: (context) => const AddAddress(),
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
