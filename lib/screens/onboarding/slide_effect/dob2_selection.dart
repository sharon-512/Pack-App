import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../custom_style.dart';

class SelectDob2 extends StatefulWidget {
  const SelectDob2({super.key});

  @override
  State<SelectDob2> createState() => _SelectDobState2();
}

class _SelectDobState2 extends State<SelectDob2> {
  int _selectedDay = 1;
  int _selectedYear = 1;
  int _selectedMonthIndex = 0;
  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              'When is your\nbirthday?',
              style: CustomTextStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Day',
                        style: CustomTextStyles.subtitleTextStyle
                            .copyWith(fontSize: 14),
                      ),
                      Container(
                        height: 76,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFFEDC0B2)),
                        ),
                        alignment: Alignment.center,
                        child: CupertinoPicker(
                          itemExtent: 76,
                          selectionOverlay: Container(
                            color: Colors.transparent,
                          ),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedDay = value + 1;
                            });
                          },
                          children: List<Widget>.generate(31, (int index) {
                            return Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontFamily: 'Aeonik',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'Month',
                        style: CustomTextStyles.subtitleTextStyle
                            .copyWith(fontSize: 14),
                      ),
                      Container(
                        height: 78,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFFEDC0B2)),
                        ),
                        alignment: Alignment.center,
                        child: CupertinoPicker(
                          itemExtent: 76,
                          selectionOverlay: Container(
                            color: Colors.transparent,
                          ),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedMonthIndex = value;
                            });
                          },
                          children: _months.map((String month) {
                            return Center(
                              child: Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontFamily: 'Aeonik',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'Year',
                        style: CustomTextStyles.subtitleTextStyle
                            .copyWith(fontSize: 14),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 76,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFFEDC0B2)),
                        ),
                        alignment: Alignment.center,
                        child: CupertinoPicker(
                          itemExtent: 76,
                          selectionOverlay: Container(
                            color: Colors.transparent,
                          ),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedYear = value + 1950;
                            });
                          },
                          children: List<Widget>.generate(2024, (int index) {
                            return const Center(
                              child: Text(
                                '${1950 + 1}',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontFamily: 'Aeonik',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
