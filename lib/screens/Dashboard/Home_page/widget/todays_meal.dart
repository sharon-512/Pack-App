import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pack_app/widgets/selected_food_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../custom_style.dart';
import '../../../../models/customer_plan.dart';
import '../../../../services/fetch_selected_meals.dart';

class CurrentDayMeals extends StatefulWidget {
  const CurrentDayMeals({Key? key}) : super(key: key);

  @override
  _CurrentDayMealsState createState() => _CurrentDayMealsState();
}

class _CurrentDayMealsState extends State<CurrentDayMeals> {
  List<String> mealTypes = [];
  List<String> mealNames = [];
  List<int> mealKcal = [];
  List<int> mealCarbs = [];
  List<int> mealProteins = [];
  List<int> mealFats = [];
  List<String> mealImages = [];
  late PageController _pageController;
  bool isLoading = true;

  final SelectedFoodApi apiService = SelectedFoodApi();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchCurrentDayMeals();
  }

  Future<void> fetchCurrentDayMeals() async {
    try {
      final customerPlan = await apiService.fetchCustomerPlan();
      final DateFormat inputDateFormat = DateFormat('dd-MM-yyyy');
      final String currentDateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final Menu? todayMenu = customerPlan.planDetails.menu.firstWhere(
            (menu) => menu.date == currentDateStr,
      );

      if (todayMenu != null && todayMenu.date.isNotEmpty) {
        if (todayMenu.breakfast != null) {
          mealTypes.add('Breakfast');
          mealNames.add(todayMenu.breakfast?.menuname ?? '');
          mealKcal.add(todayMenu.breakfast?.kcal ?? 0);
          mealProteins.add(todayMenu.breakfast?.protien ?? 0);
          mealCarbs.add(todayMenu.breakfast?.carb ?? 0);
          mealFats.add(todayMenu.breakfast?.fat ?? 0);
          mealImages.add(todayMenu.breakfast?.image ?? '');
        }

        if (todayMenu.lunch != null) {
          mealTypes.add('Lunch');
          mealNames.add(todayMenu.lunch?.menuname ?? '');
          mealKcal.add(todayMenu.lunch?.kcal ?? 0);
          mealProteins.add(todayMenu.lunch?.protien ?? 0);
          mealCarbs.add(todayMenu.lunch?.carb ?? 0);
          mealFats.add(todayMenu.lunch?.fat ?? 0);
          mealImages.add(todayMenu.lunch?.image ?? '');
        }

        if (todayMenu.snacks != null) {
          mealTypes.add('Snacks');
          mealNames.add(todayMenu.snacks?.menuname ?? '');
          mealKcal.add(todayMenu.snacks?.kcal ?? 0);
          mealProteins.add(todayMenu.snacks?.protien ?? 0);
          mealCarbs.add(todayMenu.snacks?.carb ?? 0);
          mealFats.add(todayMenu.snacks?.fat ?? 0);
          mealImages.add(todayMenu.snacks?.image ?? '');
        }

        if (todayMenu.dinner != null) {
          mealTypes.add('Dinner');
          mealNames.add(todayMenu.dinner?.menuname ?? '');
          mealKcal.add(todayMenu.dinner?.kcal ?? 0);
          mealProteins.add(todayMenu.dinner?.protien ?? 0);
          mealCarbs.add(todayMenu.dinner?.carb ?? 0);
          mealFats.add(todayMenu.dinner?.fat ?? 0);
          mealImages.add(todayMenu.dinner?.image ?? '');
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (mealNames.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Today\'s Meal Plan',
            style: CustomTextStyles.titleTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 140, // Adjust the height to fit your card
          child: PageView.builder(
            controller: _pageController,
            itemCount: mealNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: SelectedFoodCard(
                  mealTypes: mealTypes,
                  mealNames: mealNames,
                  mealKcal: mealKcal,
                  mealCarbs: mealCarbs,
                  mealProteins: mealProteins,
                  mealFats: mealFats,
                  mealImage: mealImages,
                ),
              ); // Your custom card widget
            },
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController, // PageController
            count: mealNames.length, // The number of dots
            effect: WormEffect(
              activeDotColor: Colors.grey,
              dotColor: Colors.grey[300]!,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
        ),
      ],
    );
  }
}
