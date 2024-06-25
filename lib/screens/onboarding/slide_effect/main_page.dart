import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pack_app/widgets/common_button.dart';

import '../../../widgets/progress_bar.dart';
import '../../Dashboard/nav_bar.dart';
import 'activity_level.dart';
import 'dob2_selection.dart';
import 'food_to_avoid.dart';
import 'gender_selection.dart';
import 'height_selection.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentPage > 0) {
          _pageController.animateToPage(
            _currentPage - 1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return false; // Prevents the system back button from closing the app
        } else {
          return true; // Allows the system back button to close the app or return to the previous screen
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (_currentPage > 0) {
                    _pageController.animateToPage(
                      _currentPage - 1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pop(context); // This will take the user back to the previous screen
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  physics: NeverScrollableScrollPhysics(), // This will disable manual sliding
                  children: const [
                    SelectGender2(),
                    WeightAndHeight2(),
                    SelectDob2(),
                    ActivityLevelSelection2(),
                    SpecificFood2(),
                  ],
                ),
              ),
              Column(
                children: [
                  StaticProgressBar(progress: (_currentPage+1)/5, value: _currentPage+1),
                  CommonButton(
                    onTap: () {
                      if (_currentPage < 4) {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BottomNavbar(),)
                        );
                      }
                    }, text: 'Continue',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
