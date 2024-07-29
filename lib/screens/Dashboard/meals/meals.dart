import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/screens/Dashboard/meals/widget/shimmer_effect_meals.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:pack_app/widgets/selected_food_card.dart';
import '../../../custom_style.dart';
import '../../../models/customer_plan.dart';
import '../../../services/fetch_selected_meals.dart';

class SelectedMeals extends StatefulWidget {
  const SelectedMeals({super.key});

  @override
  State<SelectedMeals> createState() => _SelectedMealsState();
}

class _SelectedMealsState extends State<SelectedMeals> {
  int selectedDay = 0;
  String planName = '';
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
  bool isLoading = true;

  final SelectedFoodApi apiService = SelectedFoodApi();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final dietPlan = await apiService.fetchDietPlan();
      final customerPlan = await apiService.fetchCustomerPlan();

      final planId = customerPlan.planDetails.id;
      final planNameFetched = dietPlan.plans
          .firstWhere((plan) => plan.planId == planId)
          .planName;

      // Extract start and end dates from the menu
      final DateFormat inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat outputDateFormat = DateFormat('MMM dd');

      List<DateTime> dates = customerPlan.planDetails.menu.map((menu) {
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

      setState(() {
        planName = planNameFetched;
        remainingDays = totalDays;
        startDateforplan = formattedStartDate;
        endDateforplan = formattedEndDate;
        remainingDays = totalDays;
        menuList = customerPlan.planDetails.menu;
        isLoading = false;
      });

      print('Plan ID: $planId');
      print('Plan Name: $planName');
      print('Start Date: $formattedStartDate');
      print('End Date: $formattedEndDate');
      print('Total Days: $totalDays');
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

      print('Selected Date: ${selectedMenu.date}');

      if (selectedMenu.breakfast != null) {
        mealTypes.add('Breakfast');
        mealNames.add(selectedMenu.breakfast?.menuname ?? '');
        mealKcal.add(selectedMenu.breakfast?.kcal ?? 0);
        mealProteins.add(selectedMenu.breakfast?.protein ?? 0);
        mealCarbs.add(selectedMenu.breakfast?.carb ?? 0);
        mealFats.add(selectedMenu.breakfast?.fat ?? 0);
        print('Breakfast:');
        print('  Name: ${selectedMenu.breakfast?.menuname}');
        print('  Kcal: ${selectedMenu.breakfast?.kcal}');
        print('  Protein: ${selectedMenu.breakfast?.protein}');
        print('  Carb: ${selectedMenu.breakfast?.carb}');
        print('  Fat: ${selectedMenu.breakfast?.fat}');
      }

      if (selectedMenu.lunch != null) {
        mealTypes.add('Lunch');
        mealNames.add(selectedMenu.lunch?.menuname ?? '');
        mealKcal.add(selectedMenu.lunch?.kcal ?? 0);
        mealProteins.add(selectedMenu.lunch?.protein ?? 0);
        mealCarbs.add(selectedMenu.lunch?.carb ?? 0);
        mealFats.add(selectedMenu.lunch?.fat ?? 0);
        print('Lunch:');
        print('  Name: ${selectedMenu.lunch?.menuname}');
        print('  Kcal: ${selectedMenu.lunch?.kcal}');
        print('  Protein: ${selectedMenu.lunch?.protein}');
        print('  Carb: ${selectedMenu.lunch?.carb}');
        print('  Fat: ${selectedMenu.lunch?.fat}');
      }

      if (selectedMenu.snacks != null) {
        mealTypes.add('Snacks');
        mealNames.add(selectedMenu.snacks?.menuname ?? '');
        mealKcal.add(selectedMenu.snacks?.kcal ?? 0);
        mealProteins.add(selectedMenu.snacks?.protein ?? 0);
        mealCarbs.add(selectedMenu.snacks?.carb ?? 0);
        mealFats.add(selectedMenu.snacks?.fat ?? 0);
        print('Snacks:');
        print('  Name: ${selectedMenu.snacks?.menuname}');
        print('  Kcal: ${selectedMenu.snacks?.kcal}');
        print('  Protein: ${selectedMenu.snacks?.protein}');
        print('  Carb: ${selectedMenu.snacks?.carb}');
        print('  Fat: ${selectedMenu.snacks?.fat}');
      }

      if (selectedMenu.dinner != null) {
        mealTypes.add('Dinner');
        mealNames.add(selectedMenu.dinner?.menuname ?? '');
        mealKcal.add(selectedMenu.dinner?.kcal ?? 0);
        mealProteins.add(selectedMenu.dinner?.protein ?? 0);
        mealCarbs.add(selectedMenu.dinner?.carb ?? 0);
        mealFats.add(selectedMenu.dinner?.fat ?? 0);
        print('Dinner:');
        print('  Name: ${selectedMenu.dinner?.menuname}');
        print('  Kcal: ${selectedMenu.dinner?.kcal}');
        print('  Protein: ${selectedMenu.dinner?.protein}');
        print('  Carb: ${selectedMenu.dinner?.carb}');
        print('  Fat: ${selectedMenu.dinner?.fat}');
      }

      // Update the UI to reflect the changes
      setState(() {});
    } else {
      print('No food details available for this date.');
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
        isLoading
            ? buildShimmerForMenuList()
            : Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
    height: 92,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: menuList.length,
    itemBuilder: (context, index) {
    // Define the texts for each container
    DateTime date =
    DateFormat('dd-MM-yyyy').parse(menuList[index].date);
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
                      mealNames.length,
                          (index) => Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: SelectedFoodCard(
                          mealTypes: mealTypes,
                          mealNames: mealNames,
                          mealKcal: mealKcal,
                          mealCarbs: mealCarbs,
                          mealProteins: mealProteins,
                          mealFats: mealFats,
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

