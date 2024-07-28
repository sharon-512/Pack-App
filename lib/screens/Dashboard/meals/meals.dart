import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:pack_app/widgets/selected_food_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../custom_style.dart';
import '../../../models/customer_plan.dart';
import '../../../models/diet_plan.dart';

class SelectedMeals extends StatefulWidget {
  const SelectedMeals({super.key});

  @override
  State<SelectedMeals> createState() => _SelectedMealsState();
}

class _SelectedMealsState extends State<SelectedMeals> {
  int selectedDay = 0;
  int selectedFoodOption = 0;
  String planName = '';
  String planDuration = '';
  String startDateforplan = '';
  String endDateforplan = '';
  int remainingDays = 0;
  List<DateTime> dates = [];
  List<String> formattedDates = [];

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

          dates = customerPlan.planDetails.menu.map((menu) {
            print('Raw Date: ${menu.date}');
            return inputDateFormat.parse(menu.date);
          }).toList();
          dates.sort((a, b) => a.compareTo(b)); // Sort dates

          final startDate = dates.first;
          final endDate = dates.last;

          final formattedStartDate = outputDateFormat.format(startDate);
          final formattedEndDate = outputDateFormat.format(endDate);

          // Calculate the total number of days in the plan duration
          final totalDays = endDate.difference(startDate).inDays +
              1; // +1 to include both start and end dates

          // Format dates for the horizontal list
          formattedDates = dates.map((date) => outputDateFormat.format(date)).toList();

          setState(() {
            planName = planNameFetched;
            remainingDays = totalDays;
            startDateforplan = formattedStartDate;
            endDateforplan = formattedEndDate;
            remainingDays = totalDays;
          });

          print('Plan ID: $planId');
          print('Plan Name: $planName');
          print('Start Date: $formattedStartDate');
          print('End Date: $formattedEndDate');
          print('Total Days: $totalDays');
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreenAppBar(showBackButton: false, titleText: 'Selected Meals'),
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: formattedDates.length,
              itemBuilder: (context, index) {
                final date = formattedDates[index];
                final splitDate = date.split(' ');
                final text1 = splitDate[0];
                final text2 = splitDate[1];
                final text3 = DateFormat('EEE').format(dates[index]);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = index; // Update the selected index
                    });
                  },
                  child: Row(
                    children: [
                      CustomContainer(
                        index == selectedDay,
                        text1,
                        text2,
                        text3,
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: SelectedFoodCard(),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomContainer(
      bool isSelected,
      String text1,
      String text2,
      String text3,
      ) {
    return Container(
      height: 90,
      width: 69,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFEDC0B2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEDC0B2), // Thicker border if selected
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text1,
            style: CustomTextStyles.labelTextStyle
                .copyWith(color: isSelected ? Colors.white : Colors.black),
          ),
          Text(
            text2,
            style: CustomTextStyles.labelTextStyle.copyWith(
                fontSize: 24, color: isSelected ? Colors.white : Colors.black),
          ),
          Text(
            text3,
            style: CustomTextStyles.labelTextStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xffABABAB)),
          ),
        ],
      ),
    );
  }
}
