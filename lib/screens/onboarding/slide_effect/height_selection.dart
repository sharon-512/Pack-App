import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_style.dart';
import '../../../providers/app_localizations.dart';
import '../../../providers/user_registration_provider.dart';

class WeightAndHeight2 extends StatefulWidget {
  const WeightAndHeight2({Key? key}) : super(key: key);

  @override
  State<WeightAndHeight2> createState() => _WeightAndHeightState();
}

class _WeightAndHeightState extends State<WeightAndHeight2> {
  int _selectedWeight = 60; // Default selected weight in kilograms
  bool _isKilograms = true; // Weight unit toggle
  int _selectedHeight = 168; // Default selected height in centimeters
  bool _isCentimeters = true; // Height unit toggle

  void _toggleUnit() {
    setState(() {
      _isKilograms = !_isKilograms;
      // Convert the weight if necessary
      _selectedWeight = _isKilograms
          ? (_selectedWeight / 2.20462).round()
          : (_selectedWeight * 2.20462).round();
    });
    _updateUserData();
  }

  void _toggleHeightUnit() {
    setState(() {
      _isCentimeters = !_isCentimeters;
      // Convert the height if necessary
      _selectedHeight = _isCentimeters
          ? (_selectedHeight)
          : (_selectedHeight * 30.48).round();
    });
    _updateUserData();
  }

  void _updateUserData() {
    // Update height and weight in UserProvider
    Provider.of<UserProvider>(context, listen: false).updateHeight(_selectedHeight.toString(),);
    Provider.of<UserProvider>(context, listen: false).updateWeight(_selectedWeight.toString(),);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                localizations!.translate('enterWeight'),
                style: CustomTextStyles.titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Container(
                height: 96,
                width: 216,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEDC0B2)),
                    borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  children: [
                    Container(
                      height: 96,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFEDC0B2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 53,
                        diameterRatio: 1.5,
                        perspective: 0.002,
                        physics: FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _selectedWeight = _isKilograms
                                ? index + 40
                                : (index + 88)
                                .round(); // Adjust for lbs if necessary
                          });
                          _updateUserData(); // Update user data on weight change
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '${_isKilograms ? 40 + index : ((40 + index) * 2.20462).round()}',
                                style: const TextStyle(
                                  fontFamily: 'Aeonik',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 40,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            );
                          },
                          childCount:
                          101, // Range from 40kg to 140kg or 88lbs to 308lbs
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white12,
                                Colors.white
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              //stops: [0.1, 0.1, 0.95], // Adjust the stops for desired effect
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Column(
                        children: [
                          _unitOption('Kg', _isKilograms),
                          _unitOption('lbs', !_isKilograms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 65),
            Center(
              child: Text(
                localizations!.translate('enterHeight'),
                style: CustomTextStyles.titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Container(
                height: 96,
                width: 216,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEDC0B2)),
                    borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFEDC0B2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 53,
                        diameterRatio: 1.5,
                        perspective: 0.002,
                        physics: FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _selectedHeight = _isCentimeters
                                ? index + 100
                                : (index + 3)
                                .round(); // Adjust for ft if necessary
                          });
                          _updateUserData(); // Update user data on height change
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '${_isCentimeters ? 100 + index : ((100 + index) / 30.48).toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontFamily: 'Aeonik',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 40,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            );
                          },
                          childCount:
                          251, // Range from 100cm to 350cm or 3ft to 11ft
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white24,
                                  Colors.white
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [.01, .5, 1]),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Column(
                        children: [
                          _unitOption('cm', _isCentimeters),
                          _unitOption('ft', !_isCentimeters),
                        ],
                      ),
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

  Widget _unitOption(String unit, bool isSelected) {
    return InkWell(
      onTap: unit == 'Kg' || unit == 'lbs' ? _toggleUnit : _toggleHeightUnit,
      child: Text(
        unit,
        style: TextStyle(
          color: isSelected ? Colors.black : Color(0xffDDDDDD),
          fontFamily: 'Aeonik',
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
    );
  }
}

