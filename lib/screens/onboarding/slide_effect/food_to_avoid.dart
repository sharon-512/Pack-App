import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../custom_style.dart';
import '../../../models/food_to_avoid_model.dart';
import '../../../providers/food_to_avoid_provider.dart';
import '../../../providers/user_registration_provider.dart';

class SpecificFood2 extends StatefulWidget {
  const SpecificFood2({super.key});

  @override
  State<SpecificFood2> createState() => _SpecificFood2();
}

class _SpecificFood2 extends State<SpecificFood2> {
  int _selectedIndex = -1;

  void _updateFoodAvoid(String foodName) {
    Provider.of<UserProvider>(context, listen: false).updateFoodAvoid(foodName);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<FoodProvider>(context, listen: false).fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      body: foodProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Are there any specific\nfood to avoid?',
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
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _updateFoodAvoid(food.foodName); // Update foodavoid with selected food name
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
              food.foodName,
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
}
