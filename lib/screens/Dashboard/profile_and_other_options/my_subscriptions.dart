// my_subscriptions.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../custom_style.dart';
import '../../../models/customer_plan.dart';
import '../../../models/diet_plan.dart';
import '../../../services/fetch_selected_meals.dart';
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

  @override
  void initState() {
    super.initState();
    fetchCustomerPlan();
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
