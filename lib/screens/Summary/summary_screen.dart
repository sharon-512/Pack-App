import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/screens/Summary/widgets/addon.dart';
import 'package:pack_app/screens/Summary/widgets/selectedItem.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_style.dart';
import '../../providers/app_localizations.dart';
import '../../services/api.dart';
import '../../services/apiPost.dart';
import '../../services/language_selection.dart';
import '../checkout/checkout.dart';

class SummaryScreen extends StatefulWidget {
  final String foodPrice;
  final String planName;
  final String planNameAr;
  final String planImage;
  final int planId;
  final int subplanId;
  final int mealtypeId;
  final double addonPrice;
  final List<Map<String, dynamic>> dailySelections;
  final List<Map<String, dynamic>> selectedAddons;
  final double totalProtein;
  final double totalCarb;
  final double totalFat ;
  final double totalKcal ;


  const SummaryScreen({
    super.key,
    required this.foodPrice,
    required this.planId,
    required this.subplanId,
    required this.mealtypeId,
    required this.planName,
    required this.planNameAr,
    required this.addonPrice,
    required this.dailySelections,
    required this.selectedAddons,
    required this.planImage,
    required this.totalProtein,
    required this.totalCarb,
    required this.totalFat,
    required this.totalKcal,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<Map<String, dynamic>> selectedAddons = [];
  late DateTime startDate;
  late DateTime endDate;
  bool _isLoading = true;
  void addDailySelections(Map<String, dynamic> selection) {
    widget.dailySelections.add(selection);
  }

  @override
  void initState() {
    super.initState();
    fetchDatesFromSharedPreferences();
    selectedAddons = widget.selectedAddons;
    print(selectedAddons);
  }

  final TextEditingController codeController = TextEditingController();
  double couponDiscount = 0.0;
  bool isCouponApplied = false;
  bool _isCouponValid = true; // Coupon validity state
  String _couponErrorMessage = ''; // Coupon error message
  String _couponSuccess = '';


  Future<void> verifyCoupon(String couponCode) async {
    setState(() {
      _isLoading = true;
      _isCouponValid = true;
      _couponErrorMessage = '';
      _couponSuccess = '';
    });
    final String url = '$baseUrl/api/verify-coupon';
    final int customerPlanId = widget.planId;

    try {
      final response = await http.post(
        Uri.parse('$url?coupon=$couponCode&customer_plan_id=$customerPlanId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          couponDiscount = double.parse(data['data']['coupon_discount_percentage'].replaceAll('%', '')) / 100;
          isCouponApplied = true;
          _couponSuccess = 'Coupon Verified Successfully';
        });
        print('Coupon verified: $data');
      } else {
        // Handle error response here
        setState(() {
          _isCouponValid = false;
          _couponErrorMessage = 'Coupon verification failed';
        });
        print('Failed to verify coupon: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isCouponValid = false;
        _couponErrorMessage = 'Coupon verification failed';
      });
      print('Error verifying coupon: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final TextEditingController code = TextEditingController();
    final double foodPrice = double.parse(widget.foodPrice);
    final double addonPrice = widget.addonPrice;
    final double subTotal = foodPrice + addonPrice;
    final double discount = _isCouponValid ? subTotal * couponDiscount : 0;
    final double totalAfterDiscount = subTotal - discount;
    final locale = Provider.of<LocaleNotifier>(context).locale;


    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: localizations!.translate('summary'),),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SelectedItem(
                          plan: locale?.languageCode == 'ar'
                              ? widget.planNameAr
                              : widget.planName,
                          price: widget.foodPrice,
                          image: widget.planImage
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (addonPrice != 0)
                          Addon(
                            plan: localizations!.translate('addOns'),
                            price: '$addonPrice',
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: codeController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff000000).withOpacity(.07)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff000000).withOpacity(.07)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  hintText: localizations!.translate('enterPromoCode'),
                                  hintStyle: CustomTextStyles.hintTextStyle,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                  verifyCoupon(codeController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                                    : Text(
                                  localizations!.translate('apply'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (_isCouponValid)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _couponSuccess,
                              style: TextStyle(color: Colors.green, fontSize: 12),
                            ),
                          ),
                        if (!_isCouponValid)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _couponErrorMessage,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
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
                                      locale?.languageCode == 'ar'
                                          ? widget.planNameAr
                                          : widget.planName ,
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      '${widget.foodPrice} ${localizations!.translate('currency')}',
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
                                        localizations!.translate('addOns'),
                                        style: CustomTextStyles.hintTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        '$addonPrice ${localizations!.translate('currency')}', // Assuming add-ons price is a fixed 100 QR
                                        style: CustomTextStyles.hintTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                Divider(
                                  color: Color(0xff000000).withOpacity(.09),
                                ),
                                if (_isCouponValid)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        localizations!.translate('discount'),
                                        style: CustomTextStyles.hintTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        '${discount.toStringAsFixed(2)} ${localizations!.translate('currency')}',
                                        style: CustomTextStyles.hintTextStyle
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                    localizations!.translate('subTotal'),
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      '${totalAfterDiscount.toStringAsFixed(2)} ${localizations!.translate('currency')}',
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Container(
                          height: 175,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff000000).withOpacity(.07)),
                              borderRadius: BorderRadius.circular(28)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Protein",
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      widget.totalProtein.toString(),
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Divider(color: Color(0xff000000).withOpacity(.09), height: 1,),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Calories",
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      widget.totalKcal.toString(),
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Divider(color: Color(0xff000000).withOpacity(.09), height: 1,),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Fat",
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      widget.totalFat.toString(),
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Divider(color: Color(0xff000000).withOpacity(.09), height: 1,),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Carbs",
                                      style: CustomTextStyles.hintTextStyle
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      widget.totalCarb.toString(),
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
                    SizedBox(height: 20,),
                    CommonButton(
                        text: localizations!.translate('checkout'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOutScreen(
                                dailySelections: widget.dailySelections,
                                selectedAddons: widget.selectedAddons,
                                planId: widget.planId,
                                subTotal: subTotal.toString(),
                                discount: discount.toString(),
                                foodPrice: widget.foodPrice,
                                addonPrice: widget.addonPrice,
                                planName: locale?.languageCode == 'ar'
                                    ? widget.planNameAr
                                    : widget.planName,
                              ),
                            ),
                          );
                        } // Call the _placeOrder method here
                        )
                  ],
                ),
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
