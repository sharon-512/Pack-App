import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/no_network_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/user_registration_provider.dart';
import '../../../services/registraction.dart';
import '../../../widgets/progress_bar.dart';
import '../../Dashboard/nav_bar.dart';
import 'activity_level.dart';
import 'dob2_selection.dart';
import 'food_to_avoid.dart';
import 'gender_selection.dart';
import 'height_selection.dart';
import '../../../models/user_model.dart'; // Assuming UserModel class for user data

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  RegistrationService _registrationService = RegistrationService();
  bool isLoading = false;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus.last == ConnectivityResult.none) {
      print('No internet connection');
    } else {
      print('Connected to the internet');
    }
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }


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
                    onTap: () async {
                      if (_currentPage < 4) {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else if (_connectionStatus.last != ConnectivityResult.none) {
                        await _registerUser();
                      }
                      else if (_connectionStatus.last == ConnectivityResult.none){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Check you internet connection')),
                        );
                      }
                    },
                    text: 'Continue',
                    isLoading: isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Print user details (for testing purposes)

      print('512 -- User Details:');
      print('First Name: ${userProvider.user.firstName}');
      print('Last Name: ${userProvider.user.lastName}');
      print('Email: ${userProvider.user.email}');
      print('Mobile Number: ${userProvider.user.mobileNumber}');
      print('Height: ${userProvider.user.height}');
      print('Weight: ${userProvider.user.weight}');
      print('Age: ${userProvider.user.age}');
      print('Gender: ${userProvider.user.gender}');
      print('Activity Level: ${userProvider.user.activityLevel}');
      print('Food to Avoid: ${userProvider.user.foodAvoid}');

      final response = await _registrationService.newRegister(userProvider.user);

      if (response['response_code'] == 3) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Store authentication status
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavbar(),
          ),
        );
        // Store user details locally using Hive
        final userBox = await Hive.openBox<User>('userBox');
        final user = User.fromJson(response['user']);
        await userBox.put('currentUser', user); // Assuming toUserModel converts to UserModel
        String userId = user.id.toString();
        final SharedPreferences() = await SharedPreferences.getInstance();
        await prefs.setString('bearerToken', response['token']); // Store the token
        await prefs.setString('userId', userId); // Store the user ID
      } else if (response['response_code'] == 0) {
        _showErrorSnackBar('Existing email ID');
      } else {
        _showErrorSnackBar('Failed to register');
      }
    } catch (error) {
      // Handle errors appropriately
      print('Failed to register user: $error');
      _showErrorSnackBar('Failed to register');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
