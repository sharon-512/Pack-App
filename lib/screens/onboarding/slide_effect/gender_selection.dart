import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../custom_style.dart';
import '../../../providers/app_localizations.dart';
import '../../../providers/user_registration_provider.dart'; // Import the UserProvider

class SelectGender2 extends StatefulWidget {
  const SelectGender2({super.key});

  @override
  State<SelectGender2> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender2> {
  String _selectedGender = '';

  void _selectGender(String gender, UserProvider userProvider) {
    setState(() {
      _selectedGender = gender;
    });

    // Update the gender in the user provider
    userProvider.updateGender(gender);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    Color _activeColor = Color(0xFFFFEDE7);
    Color _defaultColor = Colors.white;
    Color _borderColor = Color(0xFFEDC0B2);
    double _heightWidth = 135.0;

    BoxDecoration _boxDecoration(Color color) {
      return BoxDecoration(
        color: color,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8.0),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              localizations!.translate('genderIdentification'),
              style: CustomTextStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 62),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => _selectGender('male', Provider.of<UserProvider>(context, listen: false)),
                child: Column(
                  children: [
                    Container(
                      decoration: _boxDecoration(_selectedGender == 'male'
                          ? _activeColor
                          : _defaultColor),
                      height: _heightWidth,
                      width: _heightWidth,
                      child: Image.asset(
                        'assets/images/male2.png',
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    Text(
                    localizations!.translate('male'),
                      style: CustomTextStyles.labelTextStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20), // Spacing between containers
              GestureDetector(
                onTap: () => _selectGender('female', Provider.of<UserProvider>(context, listen: false)),
                child: Column(
                  children: [
                    Container(
                      decoration: _boxDecoration(_selectedGender == 'female'
                          ? _activeColor
                          : _defaultColor),
                      height: _heightWidth,
                      width: _heightWidth,
                      child: Image.asset('assets/images/female.png',
                          alignment: Alignment.bottomCenter),
                    ),
                    Text(
                      localizations!.translate('female'),
                      style: CustomTextStyles.labelTextStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
