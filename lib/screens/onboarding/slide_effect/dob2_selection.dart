import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_style.dart';
import '../../../providers/app_localizations.dart';
import '../../../providers/user_registration_provider.dart';

class SelectDob2 extends StatefulWidget {
  const SelectDob2({super.key});

  @override
  State<SelectDob2> createState() => _SelectDobState2();
}

class _SelectDobState2 extends State<SelectDob2> {
  int _selectedDay = 1;
  int _selectedYear = 1950; // Initial value adjusted for demonstration
  int _selectedMonthIndex = 0;
  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  void _calculateAgeAndStore(BuildContext context) {
    // Calculate age based on selected date of birth
    DateTime currentDate = DateTime.now();
    DateTime selectedDateOfBirth = DateTime(_selectedYear, _selectedMonthIndex + 1, _selectedDay);
    int age = currentDate.year - selectedDateOfBirth.year;
    if (currentDate.month < selectedDateOfBirth.month ||
        (currentDate.month == selectedDateOfBirth.month && currentDate.day < selectedDateOfBirth.day)) {
      age--;
    }

    // Update age in UserProvider
    Provider.of<UserProvider>(context, listen: false).updateAge(age.toString());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              localizations!.translate('birthday'),
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
                        localizations!.translate('day'),
                        style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 14),
                      ),
                      Container(
                        height: 76,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFFEDC0B2)),
                        ),
                        alignment: Alignment.center,
                        child: CupertinoPicker(
                          itemExtent: 76,
                          selectionOverlay: Container(color: Colors.transparent),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedDay = value + 1;
                            });
                            _calculateAgeAndStore(context); // Update age when day changes
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
                        localizations!.translate('month'),
                        style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 14),
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
                          selectionOverlay: Container(color: Colors.transparent),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedMonthIndex = value;
                            });
                            _calculateAgeAndStore(context); // Update age when month changes
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
                        localizations!.translate('year'),
                        style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 14),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 76,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Color(0xFFEDC0B2)),
                        ),
                        alignment: Alignment.center,
                        child: CupertinoPicker(
                          itemExtent: 76,
                          selectionOverlay: Container(color: Colors.transparent),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedYear = value + 1950;
                            });
                            _calculateAgeAndStore(context); // Update age when year changes
                          },
                          children: List<Widget>.generate(75, (int index) {
                            return Center(
                              child: Text(
                                '${1950 + index}',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

