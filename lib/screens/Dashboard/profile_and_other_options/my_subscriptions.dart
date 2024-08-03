// my_subscriptions.dart
import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../custom_style.dart';
import '../../../models/customer_plan.dart';
import '../../../models/diet_plan.dart';
import '../../../services/fetch_selected_meals.dart';
import '../../../widgets/no_network_widget.dart';
import '../Home_page/widget/selected_pack_card.dart';

class MySubscriptions extends StatefulWidget {
  const MySubscriptions({Key? key}) : super(key: key);

  @override
  State<MySubscriptions> createState() => _MySubscriptionsState();
}

class _MySubscriptionsState extends State<MySubscriptions> {
  String planName = '';
  String planDuration = '';
  String startDateforplan = '';
  String endDateforplan = '';
  int remainingDays = 0;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    fetchCustomerPlan();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus.last == ConnectivityResult.none) {
      print('No internet connection');
    } else {
      print('Connected to the internet');
    }
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }


  Future<void> fetchCustomerPlan() async {
    final data = await SelectedFoodApi.subscriptionDetails();

    if (data.isNotEmpty) {
      final subscription = data['data']['subscription'][0];
      final DateFormat inputDateFormat = DateFormat('yyyy-MM-dd');
      final DateFormat outputDateFormat = DateFormat('MMM dd');

      final startDate = inputDateFormat.parse(subscription['start_date']);
      final endDate = inputDateFormat.parse(subscription['end_date']);

      final formattedStartDate = outputDateFormat.format(startDate);
      final formattedEndDate = outputDateFormat.format(endDate);
      final DateTime today = DateTime.now();
      final int daysLeft = endDate.difference(today).inDays + 1; // +1 to include the end date

      setState(() {
        planName = subscription['plan'];
        planDuration = subscription ['calorie_plan'];
        remainingDays = daysLeft;
        startDateforplan = formattedStartDate;
        endDateforplan = formattedEndDate;
        remainingDays = daysLeft;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'My Subscriptions'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectedPackCard(
                    planName: planName, planDuration: planDuration),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 92, // Height set to 92
                        decoration: BoxDecoration(
                          color: Color(
                              0xFF124734), // Background color for the 1st container
                          borderRadius: BorderRadius.circular(
                              10), // Radius of 10 pixels
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/note.png'),
                              SizedBox(height: 5),
                              Text(
                                'Plan Start',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                startDateforplan,
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        height: 92, // Height set to 92
                        decoration: BoxDecoration(
                          color: Color(
                              0xFFBBC392), // Background color for the 2nd container
                          borderRadius: BorderRadius.circular(
                              10), // Radius of 10 pixels
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/note.png',
                                color: Color(0xff8D9858),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Plan ends',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                endDateforplan,
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        height: 92, // Height set to 92
                        decoration: BoxDecoration(
                          color: Color(
                              0xFFA8353A), // Background color for the 3rd container
                          borderRadius: BorderRadius.circular(
                              10), // Radius of 10 pixels
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/timer.png'),
                              SizedBox(height: 5),
                              Text(
                                'Remaining',
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                remainingDays.toString(),
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
