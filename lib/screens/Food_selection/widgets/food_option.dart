import 'package:flutter/material.dart';

class FoodOptions extends StatelessWidget {
  final int selectedFoodOption;
  final List<String> foodOptions;
  final Function(int) onSelectFoodOption;

  const FoodOptions({
    Key? key,
    required this.selectedFoodOption,
    required this.foodOptions,
    required this.onSelectFoodOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xffFFF7E2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Scrollable list of food options
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(foodOptions.length, (index) {
                  return GestureDetector(
                    onTap: () => onSelectFoodOption(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedFoodOption == index
                            ? const Color(0xFFFEC66F)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: selectedFoodOption == index
                              ? const Color(0xFFFEC66F)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          foodOptions[index],
                          style: TextStyle(
                            color: selectedFoodOption == index
                                ? Colors.black
                                : const Color(0xFFA89B87),
                            fontSize: 13,
                            //fontFamily: 'Aeonik',
                            letterSpacing: 0.14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // 'Addons' item (fixed at the end)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: selectedFoodOption == foodOptions.length
                  ? const Color(0xFFFEC66F)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: selectedFoodOption == foodOptions.length
                    ? const Color(0xFFFEC66F)
                    : Colors.transparent,
              ),
            ),
            child: GestureDetector(
              onTap: () => onSelectFoodOption(foodOptions.length),
              child: Center(
                child: Text(
                  'Addons',
                  style: TextStyle(
                    color: selectedFoodOption == foodOptions.length
                        ? Colors.black
                        : const Color(0xFFA89B87),
                    fontSize: 13,
                    //fontFamily: 'Aeonik',
                    letterSpacing: 0.14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
