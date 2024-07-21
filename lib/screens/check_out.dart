import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/screens/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import '../services/apiPost.dart';
import 'add_address.dart';
import '../custom_style.dart';

class CheckOutScreen extends StatefulWidget {
  final int planId;
  final String subTotal;
  final List<Map<String, dynamic>> dailySelections;
  final List<Map<String, dynamic>> selectedAddons;
  final String foodPrice;
  final String planName;
  final double addonPrice;

  const CheckOutScreen(
      {Key? key,
        required this.dailySelections,
        required this.selectedAddons,
        required this.planId,
        required this.subTotal,
        required this.foodPrice,
        required this.planName,
        required this.addonPrice})
      : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<Map<String, dynamic>> dailySelections = [];
  List<Map<String, dynamic>> selectedAddons = [];
  late DateTime startDate;
  late DateTime endDate;
  bool _isLoading = true;
  String? _selectedOption;
  int _deliveryFee = 0;
  bool _isButtonEnabled = false;
  // Address details
  String? _selectedAddress;
  String? _streetNumber;
  String? _buildingNo;
  String? _flatNo;
  String? _mobileNo;
  // List of addresses for dropdown
  List<String> _addresses = [];

  void addDailySelections(Map<String, dynamic> selection) {
    dailySelections.add(selection);
  }

  final List<Map<String, dynamic>> _options = [
    {'text': 'Inside Doha - 200 QR', 'value': 200},
    {'text': 'Outside Doha - 250 QR', 'value': 250},
  ];

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _selectedAddress != null && _selectedOption != null;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDatesFromSharedPreferences();
    // Initialize addresses if needed
    _addresses = []; // You can fetch or set initial addresses here
  }

  @override
  Widget build(BuildContext context) {
    final double foodPrice = double.parse(widget.foodPrice);
    final double addonPrice = widget.addonPrice;
    double subTotal = foodPrice + addonPrice + _deliveryFee;
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
                              Padding(
                                padding: const EdgeInsets.only(left: 35),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(12),
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down_rounded,
                                        size: 28),
                                    value: _selectedAddress,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedAddress = newValue!;
                                      });
                                      _updateButtonState();
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
                                                maxLines: 1,
                                                style: CustomTextStyles.titleTextStyle
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAddress(),
                            ),
                          );

                          if (result != null && result is Map<String, String>) {
                            setState(() {
                              _selectedAddress = result['address'];
                              _streetNumber = result['streetNo'];
                              _buildingNo = result['buildingNo'];
                              _flatNo = result['flatNo'];
                              _mobileNo = result['mobileNo'];

                              // Optionally update the list of addresses
                              if (!_addresses.contains(_selectedAddress)) {
                                _addresses.add(_selectedAddress!);
                              }
                            });
                            _updateButtonState();
                          }
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
                        'Delivery fee',
                        style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff000000).withOpacity(.07)),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(12),
                              value: _selectedOption,
                              hint: Text('Select delivery fee'),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down_rounded, size: 28),
                              items: _options.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option['text'],
                                  child: Text(option['text'],style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400
                                  ),),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedOption = newValue;
                                  _deliveryFee = _options
                                      .firstWhere((option) => option['text'] == newValue)['value'];
                                  //subTotal = subTotal + _deliveryFee;
                                });
                                _updateButtonState();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
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
                                      '$addonPrice QR',
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
                                    'Delivery Fee',
                                    style: CustomTextStyles.hintTextStyle
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '$_deliveryFee QR',
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
                      ),
                    ],
                  ),
                  _isButtonEnabled ?
                  CommonButton(
                      text: 'Check Out',
                      onTap: _placeOrder,

                  )
                      : Container(
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(28)),
                    alignment: Alignment.center,
                    child: Text('Check Out',
                      style: TextStyle(
                        fontFamily: 'Aeonik',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),),
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
    final double foodPrice = double.parse(widget.foodPrice);
    final double addonPrice = widget.addonPrice;
    double subTotal = foodPrice + addonPrice + _deliveryFee;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('bearerToken');
      String? userId = prefs.getString('userId');
      if (userId == null) {
        print('No id');
        return;
      }
      if (token == null) {
        print('Token not found in SharedPreferences');
        return;
      }
      var result = await ApiService.placeOrder(
        token: token,
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        productId: widget.planId.toString(),
        dailySelections: widget.dailySelections,
        selectedAddons: widget.selectedAddons,
        address: _selectedAddress ?? 'Your address here',
        streetNo: _streetNumber ?? 'Your street number here',
        buildingNo: _buildingNo ?? 'Your building number here',
        flatNo: _flatNo ?? 'Your flat number here',
        mobileNo: _mobileNo ?? 'Your mobile number here',
      );

      if (result['success']) {
        print('Order saved successfully.');
        print('Response: ${result['data']}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              subTotal: subTotal,
              planName: widget.planName,),
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
