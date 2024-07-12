import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            Image.network(
              widget.foodData['menu_image'],
              width: 100,
              height: 100,
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
                        SvgPicture.asset('assets/images/fire.svg'),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            '${widget.foodData['calories']} kcal • ${widget.foodData['weight']} g',
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
                          label: '${widget.foodData['protein']}g',
                          widthFactor: 25,
                          label2: ' Protein',
                          isSelected: widget.isSelected,
                        ),
                        NutritionBar(
                          color: const Color(0xffF7C648),
                          label: '${widget.foodData['carbs']}g',
                          widthFactor: 35,
                          label2: ' Carbs',
                          isSelected: widget.isSelected,
                        ),
                        NutritionBar(
                          color: const Color(0xffA8353A),
                          label: '${widget.foodData['fat']}g',
                          widthFactor: 20,
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
