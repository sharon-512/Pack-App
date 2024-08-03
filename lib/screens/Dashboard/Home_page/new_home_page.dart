import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/screens/Dashboard/Home_page/widget/banner_card.dart';
import 'package:pack_app/screens/Dashboard/Home_page/widget/homepage_shimmer.dart';
import 'package:pack_app/screens/Dashboard/Home_page/widget/selected_pack_card.dart';
import 'package:pack_app/screens/Dashboard/Home_page/widget/todays_meal.dart';

import '../../../models/user_model.dart';
import '../../../services/fetch_selected_meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  String planName = '';
  String planDuration = '';
  String startDateforplan = '';
  String endDateforplan = '';
  int remainingDays = 0;
  bool isLoading = true; // Add a loading state

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

      final totalDays = endDate.difference(startDate).inDays + 1; // +1 to include the end date
      final today = DateTime.now();
      //final daysPassed = today.difference(startDate).inDays;
      //final remainingDays = totalDays - daysPassed;
      final remainingDays = totalDays ;

      setState(() {
        planName = subscription['plan'];
        planDuration = subscription['calorie_plan'];
        startDateforplan = formattedStartDate;
        endDateforplan = formattedEndDate;
        this.remainingDays = remainingDays > 0 ? remainingDays : 0; // Ensure remainingDays is not negative
        isLoading = false; // Set loading to false after data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');

    return Scaffold(
      body: isLoading ? const HomePageShimmer() : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('512${user!.image}');
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image(
                              image: user?.image != null
                                  ? FileImage(File(user!.image!))
                                  : const AssetImage('assets/images/profile_place_holder.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                              width: 60.0,
                              height: 60.0,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/profile_place_holder.jpg',
                                  fit: BoxFit.cover,
                                  width: 60.0,
                                  height: 60.0,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/hand_emoji.png'),
                              Text(
                                'Hello! ${user?.firstname}',
                                style: CustomTextStyles.labelTextStyle.copyWith(
                                    color: Color(0xffD7D7D7), fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            'Welcome to Pack',
                            style: CustomTextStyles.labelTextStyle
                                .copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedPackCard(
                      planName: planName, planDuration: planDuration),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 92,
                          decoration: BoxDecoration(
                            color: const Color(0xFF124734),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/note.png'),
                                const SizedBox(height: 5),
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 92,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBC392),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/note.png',
                                  color: const Color(0xff8D9858),
                                ),
                                const SizedBox(height: 5),
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 92,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA8353A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/timer.png'),
                                const SizedBox(height: 5),
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
                  const SizedBox(height: 10),
                  BannerCardWidget(),
                  const SizedBox(height: 15),
                  const CurrentDayMeals(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
