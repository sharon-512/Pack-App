import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedFoodCard extends StatelessWidget {
  final List<String> mealTypes;
  final List<String> mealNames;
  final List<int> mealKcal;
  final List<int> mealCarbs;
  final List<int> mealProteins;
  final List<int> mealFats;
  final List<String> mealImage;

  SelectedFoodCard({
    required this.mealTypes,
    required this.mealNames,
    required this.mealKcal,
    required this.mealCarbs,
    required this.mealProteins,
    required this.mealFats,
    required this.mealImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(mealNames.length, (index) {
        return Container(
          height: 140,
          margin: EdgeInsets.symmetric(vertical: 5), // Add margin between cards
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Color(0xffEDC0B2)),
          ),
          child: Row(
            children: [
              SizedBox(width: 10),
              // Image.asset(
              //   imagePath, // Image path from parameter
              //   width: 100,
              //   height: 100,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 0, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              mealImage[index],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mealNames[index], // Meal name from list
                                style: CustomTextStyles.labelTextStyle
                                    .copyWith(fontSize: 20),
                              ),
                              Row(
                                children: mealTypes
                                    .map((mealType) => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 30,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Color(0xff124734),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            mealType,
                                            style: CustomTextStyles
                                                .titleTextStyle
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/images/fire.svg'),
                                  Text(
                                    '${mealKcal[index]} kcal • ${mealProteins[index]} g',
                                    style: CustomTextStyles.subtitleTextStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  NutritionBar(
                                    color: const Color(0xffBBC392),
                                    label: '${mealProteins[index]} g',
                                    widthFactor: mealProteins[index] / 100 * 50,
                                    label2: ' Protein',
                                  ), // Adjust the widthFactor as needed
                                  NutritionBar(
                                    color: const Color(0xffF7C648),
                                    label: '${mealCarbs[index]} g',
                                    widthFactor: mealCarbs[index] / 100 * 50,
                                    label2: ' Carbs',
                                  ), // Adjust the widthFactor as needed
                                  NutritionBar(
                                    color: const Color(0xffA8353A),
                                    label: '${mealFats[index]} g',
                                    widthFactor: mealFats[index] / 100 * 50,
                                    label2: ' Fat',
                                  ), // Adjust the widthFactor as needed
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class NutritionBar extends StatelessWidget {
  final Color color;
  final String label;
  final String label2;
  final double widthFactor; // Added to control the width of the bar

  NutritionBar({
    required this.color,
    required this.label,
    required this.widthFactor,
    required this.label2, // Width factor parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Aeonik',
                fontWeight: FontWeight.w400,
                fontSize: 10.0,
              ),
              children: <TextSpan>[
                TextSpan(text: label),
                TextSpan(
                    text: label2, style: TextStyle(color: Color(0xffA5A5A5))),
              ],
            ),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 4,
                width: widthFactor,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
