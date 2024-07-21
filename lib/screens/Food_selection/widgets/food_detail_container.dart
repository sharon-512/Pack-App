import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pack_app/custom_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FoodInfoCard extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Map<String, dynamic> foodData;

  const FoodInfoCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.foodData,
  });

  @override
  State<FoodInfoCard> createState() => _FoodInfoCardState();
}

class _FoodInfoCardState extends State<FoodInfoCard> {
  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isSelected ? Color(0xff54423C) : Colors.black;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        height: 115,
        decoration: BoxDecoration(
          color: widget.isSelected ? Color(0xffEDC0B2) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Color(0xffEDC0B2)),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.foodData['menu_image'],
                width: 90,
                height: 90,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    width: 90,
                    height: 90,
                    child: Icon(
                      Icons.sms_failed_outlined,
                      color: Colors.grey[700],
                    ),
                  );
                },
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 90,
                        height: 90,
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.foodData['menu_name'] ?? 'Food Name',
                        style: CustomTextStyles.labelTextStyle.copyWith(
                          fontSize: 20,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/fire2.png', height: 14, width: 13,),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '${widget.foodData['kcal']} kcal',
                            style: CustomTextStyles.subtitleTextStyle.copyWith(
                              fontSize: 12,
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NutritionBar(
                          color: const Color(0xffBBC392),
                          label: '${widget.foodData['protien']}g',
                          widthFactor: widget.foodData['protien'].toDouble(),
                          label2: ' Protein',
                          isSelected: widget.isSelected,
                        ),
                        NutritionBar(
                          color: const Color(0xffF7C648),
                          label: '${widget.foodData['carb']}g',
                          widthFactor: widget.foodData['carb'].toDouble(),
                          label2: ' Carbs',
                          isSelected: widget.isSelected,
                        ),
                        NutritionBar(
                          color: const Color(0xffA8353A),
                          label: '${widget.foodData['fat']}g',
                          widthFactor: widget.foodData['fat'].toDouble(),
                          label2: ' Fat',
                          isSelected: widget.isSelected,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionBar extends StatelessWidget {
  final Color color;
  final String label;
  final String label2;
  final double widthFactor;
  final bool isSelected;

  NutritionBar({
    required this.color,
    required this.label,
    required this.widthFactor,
    required this.label2,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = isSelected ? Color(0xff54423C) : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: textColor,
                fontFamily: 'Aeonik',
                fontWeight: FontWeight.w400,
                fontSize: 10.0,
              ),
              children: <TextSpan>[
                TextSpan(text: label),
                TextSpan(
                  text: label2,
                  style: TextStyle(color: isSelected ? Color(0xff54423C) : Color(0xffA5A5A5)),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Color(0xffD9D9D9),
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

