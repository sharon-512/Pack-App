import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../custom_style.dart';
import '../../../models/food_to_avoid_model.dart';
import '../../../providers/app_localizations.dart';
import '../../../providers/food_to_avoid_provider.dart';
import '../../../providers/user_registration_provider.dart';
import '../../../services/language_selection.dart';

class SpecificFood2 extends StatefulWidget {
  const SpecificFood2({Key? key}) : super(key: key);

  @override
  State<SpecificFood2> createState() => _SpecificFood2();
}

class _SpecificFood2 extends State<SpecificFood2> {
  List<String> _selectedFoods = [];

  void _updateFoodAvoid() {
    print('Selected foods to avoid: $_selectedFoods');
    Provider.of<UserProvider>(context, listen: false).updateFoodAvoidList(_selectedFoods);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<FoodProvider>(context, listen: false).fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      body: foodProvider.isLoading
          ? _buildShimmerEffect()
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
            child: Text(
              localizations!.translate('foodAvoidance'),
              style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: foodProvider.foods.length,
              itemBuilder: (context, index) {
                final food = foodProvider.foods[index];
                return _buildContainer(index, food);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(int index, Food food) {
    final locale = Provider.of<LocaleNotifier>(context).locale;
    bool isSelected = _selectedFoods.contains(food.foodName);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedFoods.remove(food.foodName);
          } else {
            _selectedFoods.add(food.foodName);
          }
          _updateFoodAvoid();
        });
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEDC0B2) : Colors.transparent,
          border: Border.all(color: Color(0xFFEDC0B2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(food.imageUrl, fit: BoxFit.fill, height: 37, width: 37),
            Text(
              locale?.languageCode == 'ar'
                  ? food.foodNameAr
                  : food.foodName,
              style: TextStyle(
                fontFamily: 'Aeonik',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    final localizations = AppLocalizations.of(context)!;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
            child: Text(
              localizations!.translate('foodAvoidance'),
              style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: 6, // Display 6 shimmer items
              itemBuilder: (context, index) {
                return _buildShimmerContainer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
