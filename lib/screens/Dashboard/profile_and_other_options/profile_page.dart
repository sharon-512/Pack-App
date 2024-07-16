import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/privacy_policy.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/terms_and_conditions.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../onboarding/start_screen.dart';
import 'Add_new_address.dart';
import 'Help_and_support.dart';
import 'edit_profile.dart';
import 'languages.dart';
import 'my_coupons.dart';
import 'my_subscriptions.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});
  void _clearSharedPreferences(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Remove the isLoggedIn key from shared preferences
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GreenAppBar(showBackButton: false, titleText: 'My Profile'),
              SizedBox(height: 12,),
              CircleAvatar(radius: 40,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/profile_pic2.png',fit: BoxFit.fill,)
              ),
              const Text(
                'Mariam Ahmed',
                style: TextStyle(
                  fontFamily: 'Aeonik',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
              const Text('+974 3344 6568',
                style: TextStyle(
                    fontFamily: 'Aeonik',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    letterSpacing: -0.5,
                    color: Colors.grey
                ),
              ),
            ],
          ),
          Expanded( // This will take up all available space after the profile details
            child: ListView( // This will only enable scrolling for the list items
              children: [
                _buildMenuItem(context, 'My Subscription', 'assets/icons/subscription.svg', () => _navigateTo(context, MySubscriptions())),
                _buildMenuItem(context, 'My Profile', 'assets/icons/profile.svg', () => _navigateTo(context, EditProfileScreen())),
                _buildMenuItem(context, 'My Coupons', 'assets/icons/coupons.svg', () => _navigateTo(context, MyCoupons())),
                _buildMenuItem(context, 'Address', 'assets/icons/address.svg', () => _navigateTo(context, AddNewAddress())),
                _buildMenuItem(context, 'Whatsapp', 'assets/icons/whatsapp.svg', () => _navigateTo(context, MyCoupons())),
                _buildMenuItem(context, 'Language', 'assets/icons/language.svg', () => _navigateTo(context, SelectLanguage())),
                _buildMenuItem(context, 'Help & Support', 'assets/icons/headphone.svg', () => _navigateTo(context, HelpAndSupport())),
                _buildMenuItem(context, 'Privacy Policy', 'assets/icons/privacy_policy.svg', () => _navigateTo(context, PrivacyPolicy())),
                _buildMenuItem(context, 'Terms & Conditions', 'assets/icons/terms_conditions.svg', () => _navigateTo(context, TermsAndConditions())),
                // Add more menu items if needed
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 30),
                  child:  GestureDetector(
                    onTap: () {
                      _clearSharedPreferences(context); // Call the method to clear shared preferences
                      _navigateTo(context, StartScreen()); // Navigate to your logout screen or any other screen
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
}