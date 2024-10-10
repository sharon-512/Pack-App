import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/screens/Dashboard/meals/widget/shimmer_effect_meals.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:pack_app/widgets/selected_food_card.dart';
import '../../../custom_style.dart';
import '../../../models/customer_plan.dart';
import '../../../providers/app_localizations.dart';
import '../../../services/fetch_selected_meals.dart';
import '../../../widgets/no_network_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../profile_and_other_options/widgets/banner.dart';

class SelectedMeals extends StatefulWidget {
  const SelectedMeals({super.key});

  @override
  State<SelectedMeals> createState() => _SelectedMealsState();
}

class _SelectedMealsState extends State<SelectedMeals> {
  int selectedDay = 0;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String startDateforplan = '';
  String endDateforplan = '';
  int remainingDays = 0;
  List<Menu> menuList = [];
  List<String> mealTypes = [];
  List<String> mealNames = [];
  List<int> mealKcal = [];
  List<int> mealCarbs = [];
  List<int> mealProteins = [];
  List<int> mealFats = [];
  List<String> mealImages = [];
  bool isLoading = true;

  final SelectedFoodApi apiService = SelectedFoodApi();

  @override
  void initState() {
    super.initState();
    fetchData();
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

  Future<void> fetchData() async {
    try {
      final customerPlan = await apiService.fetchCustomerPlan();
      final DateFormat inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat outputDateFormat = DateFormat('MMM dd');
      List<DateTime> dates = customerPlan.planDetails.menu.map((menu) => inputDateFormat.parse(menu.date)).toList();
      dates.sort((a, b) => a.compareTo(b));
      final startDate = dates.first;
      final endDate = dates.last;
      final formattedStartDate = outputDateFormat.format(startDate);
      final formattedEndDate = outputDateFormat.format(endDate);
      final totalDays = endDate.difference(startDate).inDays + 1;
      setState(() {
        remainingDays = totalDays;
        startDateforplan = formattedStartDate;
        endDateforplan = formattedEndDate;
        menuList = customerPlan.planDetails.menu;
        isLoading = false;
      });
      printFoodDetailsForSelectedDate(0);
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void printFoodDetailsForSelectedDate(int index) {
    if (index < menuList.length) {
      final selectedMenu = menuList[index];

      // Clear previous values
      mealTypes.clear();
      mealNames.clear();
      mealKcal.clear();
      mealCarbs.clear();
      mealProteins.clear();
      mealFats.clear();
      mealImages.clear();

      print('Selected Date: ${selectedMenu.date}');

      if (selectedMenu.breakfast != null) {
        mealTypes.add('Breakfast');
        mealNames.add(selectedMenu.breakfast?.menuname ?? '');
        mealKcal.add(selectedMenu.breakfast?.kcal ?? 0);
        mealProteins.add(selectedMenu.breakfast?.protien ?? 0);
        mealCarbs.add(selectedMenu.breakfast?.carb ?? 0);
        mealFats.add(selectedMenu.breakfast?.fat ?? 0);
        mealImages.add(selectedMenu.breakfast?.image ?? '');
      }

      if (selectedMenu.lunch != null) {
        mealTypes.add('Lunch');
        mealNames.add(selectedMenu.lunch?.menuname ?? '');
        mealKcal.add(selectedMenu.lunch?.kcal ?? 0);
        mealProteins.add(selectedMenu.lunch?.protien ?? 0);
        mealCarbs.add(selectedMenu.lunch?.carb ?? 0);
        mealFats.add(selectedMenu.lunch?.fat ?? 0);
        mealImages.add(selectedMenu.lunch?.image ?? '');
      }

      if (selectedMenu.snacks != null) {
        mealTypes.add('Snacks');
        mealNames.add(selectedMenu.snacks?.menuname ?? '');
        mealKcal.add(selectedMenu.snacks?.kcal ?? 0);
        mealProteins.add(selectedMenu.snacks?.protien ?? 0);
        mealCarbs.add(selectedMenu.snacks?.carb ?? 0);
        mealFats.add(selectedMenu.snacks?.fat ?? 0);
        mealImages.add(selectedMenu.snacks?.image ?? '');
      }

      if (selectedMenu.dinner != null) {
        mealTypes.add('Dinner');
        mealNames.add(selectedMenu.dinner?.menuname ?? '');
        mealKcal.add(selectedMenu.dinner?.kcal ?? 0);
        mealProteins.add(selectedMenu.dinner?.protien ?? 0);
        mealCarbs.add(selectedMenu.dinner?.carb ?? 0);
        mealFats.add(selectedMenu.dinner?.fat ?? 0);
        mealImages.add(selectedMenu.dinner?.image ?? '');
      }

      // Update the UI to reflect the changes
      setState(() {});
    } else {
      print('No food details available for this date.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreenAppBar(showBackButton: false, titleText: localizations!.translate('selectedMeals'),),
          const SizedBox(height: 20),
          isLoading
              ? buildShimmerForMenuList()
              : menuList.isEmpty
                  ? EmptyMeal()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: 92,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: menuList.length,
                        itemBuilder: (context, index) {
                          // Define the texts for each container
                          DateTime date = DateFormat('dd-MM-yyyy')
                              .parse(menuList[index].date);
                          String text1 = DateFormat('MMM').format(date);
                          String text2 = DateFormat('d').format(date);
                          String text3 = DateFormat('EEE').format(date);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = index; // Update the selected index
                    });
                    printFoodDetailsForSelectedDate(index);
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
                  mealNames.length, // Display a card for each meal
                      (index) => Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: SelectedFoodCard(
                      mealTypes: [mealTypes[index]], // Display one meal at a time
                      mealNames: [mealNames[index]],
                      mealKcal: [mealKcal[index]],
                      mealCarbs: [mealCarbs[index]],
                      mealProteins: [mealProteins[index]],
                      mealFats: [mealFats[index]],
                      mealImage: [mealImages[index]],
                    ),
                  ),
                ),
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
