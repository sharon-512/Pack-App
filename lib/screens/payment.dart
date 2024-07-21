import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/screens/Dashboard/nav_bar.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class PaymentScreen extends StatefulWidget {
  final double subTotal;
  final String planName;

  const PaymentScreen({super.key,
    required this.subTotal,
    required this.planName
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  DateTime? startDate;
  DateTime? endDate;
  bool _isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    fetchDatesFromSharedPreferences(); // Fetch dates when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');
    final String formattedDate = DateFormat('d MMMM yyyy . hh:mm a').format(DateTime.now());
    final int generatedId = Random().nextInt(10000); // Generates a random ID between 0 and 9999

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/payment_bg.png'),
            fit: BoxFit.cover,
          ),
          gradient: RadialGradient(
            center: Alignment(0.2698, -0.3198),
            radius: 2,
            colors: [
              Color(0xFF002216), // Dark color
              Color(0xFF124734), // Light color
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/tick3.png'),
            const Text(
              'Order Successful',
              style: TextStyle(
                  fontFamily: 'Aeonik',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.41),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 360,
              width: 310,
              child: Stack(
                children: [
                  Container(
                    height: 360,
                    width: 310,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bill_bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${widget.subTotal} QR',
                              style: const TextStyle(
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w700,
                                fontSize: 34,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Color(0xffB6B6B6),
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item name',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Order NO',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Customer Name',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'Start Date',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    'End Date',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.planName,
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    generatedId.toString(),
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  Text(
                                    user!.firstname ?? 'name',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14, letterSpacing: -0.14),
                                  ),
                                  _isLoading
                                      ? const CircularProgressIndicator()
                                      : Text(
                                    startDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                        .format(startDate!)
                                        : '------',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14,
                                        letterSpacing: -0.14),
                                  ),
                                  _isLoading
                                      ? const CircularProgressIndicator()
                                      : Text(
                                    endDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                        .format(endDate!)
                                        : '------',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                        fontSize: 14,
                                        letterSpacing: -0.14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _shareReceipt,
                          child: Container(
                            width: 260,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffFBC56D),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/share.svg'),
                                Text(
                                  '  Share Receipt',
                                  style: CustomTextStyles.labelTextStyle
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavbar(selectedIndex: 0),
                      ));
                },
                child: SvgPicture.asset('assets/images/exit.svg')),
          ],
        ),
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
          startDate = DateFormat('EEEE, MMMM d, yyyy').parse(storedStartDate);
          endDate = DateFormat('EEEE, MMMM d, yyyy').parse(storedEndDate);
          _isLoading = false;
        });
      } catch (e) {
        print('Error parsing dates: $e');
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
    }
  }

  void _shareReceipt() {
    final String receiptDetails = '''
    Plan Name: ${widget.planName}
    Order No: ${Random().nextInt(10000)}
    Customer Name: ${Hive.box<User>('userBox').get('currentUser')!.firstname ?? 'name'}
    Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : '------'}
    End Date: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : '------'}
    Total: ${widget.subTotal} QR
    ''';

    Share.share(receiptDetails, subject: 'Receipt Details');
  }
}


