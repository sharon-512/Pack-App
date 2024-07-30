import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_style.dart';
import '../../../models/customer_plan.dart';
import '../../../models/diet_plan.dart';
import '../Home_page/widget/banner_card.dart';
import '../Home_page/widget/selected_pack_card.dart';
import 'package:http/http.dart' as http;

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
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('bearerToken');
    final String customerPlanUrl =
        'https://interfuel.qa/packupadmin/api/view-customer-plan';
    final String dietPlanUrl =
        'https://interfuel.qa/packupadmin/api/get-diet-data';

    try {
      final dietPlanResponse = await http.get(
        Uri.parse(dietPlanUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (dietPlanResponse.statusCode == 200) {
        final dietPlanData = json.decode(dietPlanResponse.body);
        final dietPlan = DietPlan.fromJson(dietPlanData);

        final customerPlanResponse = await http.post(
          Uri.parse(customerPlanUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (customerPlanResponse.statusCode == 200) {
          final customerPlanData = json.decode(customerPlanResponse.body);
          final customerPlan = CustomerPlan.fromJson(customerPlanData);

          final planId = customerPlan.planDetails.id;
          final planNameFetched = dietPlan.plans
              .firstWhere((plan) => plan.planId == planId)
              .planName;

          // Extract start and end dates from the menu
          final DateFormat inputDateFormat = DateFormat('dd-MM-yyyy');
          final DateFormat outputDateFormat = DateFormat('MMM dd');

          List<DateTime> dates = customerPlan.planDetails.menu.map((menu) {
            print('Raw Date: ${menu.date}');
            return inputDateFormat.parse(menu.date);
          }).toList();
          dates.sort((a, b) => a.compareTo(b)); // Sort dates

          final startDate = dates.first;
          final endDate = dates.last;

          final formattedStartDate = outputDateFormat.format(startDate);
          final formattedEndDate = outputDateFormat.format(endDate);
          final DateTime today = DateTime.now();
          final int daysLeft = endDate.difference(today).inDays + 1; // +1 to include the end date


          setState(() {
            planName = planNameFetched;
            remainingDays = daysLeft;
            startDateforplan = formattedStartDate;
            endDateforplan = formattedEndDate;
            remainingDays = daysLeft;
          });

          print('Plan ID: $planId');
          print('Plan Name: $planName');
          print('Start Date: $formattedStartDate');
          print('End Date: $formattedEndDate');
          print('Total Days: $daysLeft');
        } else {
          print(
              'Failed to load customer plan. Status code: ${customerPlanResponse.statusCode}');
        }
      } else {
        print(
            'Failed to load diet plans. Status code: ${dietPlanResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
                    planName: planName, planDuration: '3 Week Plan'),
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
                                style:
                                CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                startDateforplan,
                                style:
                                CustomTextStyles.titleTextStyle.copyWith(
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
                                style:
                                CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                endDateforplan,
                                style:
                                CustomTextStyles.titleTextStyle.copyWith(
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
                                style:
                                CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                remainingDays.toString(),
                                style:
                                CustomTextStyles.titleTextStyle.copyWith(
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
