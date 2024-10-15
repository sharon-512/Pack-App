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

      if (todayMenu != null) {
        for (var meal in todayMenu.meals) {
          mealTypes.add(meal.type);
          mealNames.add(meal.menuname);
          mealKcal.add(meal.kcal);
          mealProteins.add(meal.protien);
          mealCarbs.add(meal.carb);
          mealFats.add(meal.fat);
          mealImages.add(meal.image);
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
          height: 120, // Adjust the height to fit your card
          child: PageView.builder(
            controller: _pageController,
            itemCount: mealNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: SelectedFoodCard(
                  mealTypes: [mealTypes[index]], // Single item list for meal type
                  mealNames: [mealNames[index]], // Single item list for meal name
                  mealKcal: [mealKcal[index]], // Single item list for meal kcal
                  mealCarbs: [mealCarbs[index]], // Single item list for meal carbs
                  mealProteins: [mealProteins[index]], // Single item list for meal proteins
                  mealFats: [mealFats[index]], // Single item list for meal fats
                  mealImage: [mealImages[index]], // Single item for meal image
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
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
        ),
      ],
    );
  }
}
