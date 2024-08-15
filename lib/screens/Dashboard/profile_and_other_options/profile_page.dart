import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/privacy_policy.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/terms_and_conditions.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../../../services/api.dart';
import '../../../widgets/add_address.dart';
import '../../onboarding/start_screen.dart';
import 'Help_and_support.dart';
import 'edit_profile.dart';
import 'languages.dart';
import 'my_coupons.dart';
import 'my_subscriptions.dart';
import 'package:http/http.dart' as http;

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GreenAppBar(showBackButton: false, titleText: 'My Profile'),
              SizedBox(height: 12,),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image(
                    image: user?.image != null
                        ? FileImage(File(user!.image!))
                        : const AssetImage('assets/images/profile_place_holder.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                    width: 80.0,
                    height: 80.0,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/profile_place_holder.jpg',
                        fit: BoxFit.cover,
                        width: 80.0,
                        height: 80.0,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${user?.firstname ?? 'Unknown'} ${user?.lastname ?? ''}',
                style: TextStyle(
                  fontFamily: 'Aeonik',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '+974 ${user?.mobno ?? '0000 0000'}',
                style: TextStyle(
                  fontFamily: 'Aeonik',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  letterSpacing: -0.5,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(context, 'My Subscription', 'assets/icons/subscription.svg', () => _navigateTo(context, MySubscriptions())),
                _buildMenuItem(context, 'My Profile', 'assets/icons/profile.svg', () => _navigateTo(context, EditProfileScreen())),
                _buildMenuItem(context, 'My Coupons', 'assets/icons/coupons.svg', () => _navigateTo(context, MyCoupons())),
                _buildMenuItem(context, 'Address', 'assets/icons/address.svg', () => _navigateTo(context, AddAddress())),
                // _buildMenuItem(context, 'Whatsapp', 'assets/icons/whatsapp.svg', () => _navigateTo(context, MyCoupons())),
                _buildMenuItem(context, 'Language', 'assets/icons/language.svg', () => _navigateTo(context, SelectLanguage())),
                _buildMenuItem(context, 'Help & Support', 'assets/icons/headphone.svg', () => _navigateTo(context, HelpAndSupport())),
                _buildMenuItem(context, 'Privacy Policy', 'assets/icons/privacy_policy.svg', () => _navigateTo(context, PrivacyPolicy())),
                _buildMenuItem(context, 'Terms & Conditions', 'assets/icons/terms_conditions.svg', () => _navigateTo(context, TermsAndConditions())),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 30),
                  child: GestureDetector(
                    onTap: () async {
                      _showLogoutConfirmationDialog(context, 'You really want to logout?');
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Aeonik',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 14 / 15,
                        letterSpacing: -0.5,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 30),
                  child: GestureDetector(
                    onTap: () async {
                      _showLogoutConfirmationDialog(context, 'Are you sure? Your account will be deleted permanently.');
                    },
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontFamily: 'Aeonik',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 14 / 15,
                        letterSpacing: -0.5,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String svgPath, Function onTap) {
    return ListTile(
      leading: SvgPicture.asset(svgPath, width: 20, height: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Aeonik',
          fontWeight: FontWeight.w500,
          fontSize: 15,
          height: 14 / 15,
          letterSpacing: -0.5,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      onTap: () => onTap(),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set the container background color to white
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.orange,
                      size: 35.0,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'No Need',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // Call the logout API
                          final prefs = await SharedPreferences.getInstance();
                          String? token = prefs.getString('bearerToken');
                          final response = await http.get(
                            Uri.parse('$baseUrl/api/logout'),
                            headers: {
                              'Authorization': 'Bearer $token', // Replace with your actual token
                            },
                          );

                          if (response.statusCode == 200) {
                            // Clear stored user data
                            final userBox = Hive.box<User>('userBox');
                            await userBox.clear();

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('isLoggedIn');
                            await prefs.remove('bearerToken');

                            // Navigate to the start screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => StartScreen()),
                                  (route) => false,
                            );
                          } else {
                            // Handle API call failure
                            print('Failed to logout: ${response.statusCode}');
                            // Show an error message or handle accordingly
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
