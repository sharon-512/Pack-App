import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/profile_page.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController numberController = TextEditingController();

  Future<void> updateProfile(User user) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('bearerToken');
    final url = Uri.parse(
        'https://interfuel.qa/packupadmin/api/update-profile?id=${user.id}&firstname=${firstNameController.text}&lastname=${lastNameController.text}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': user.id,
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      final responseBody = jsonDecode(response.body);
      print('Response JSON: $responseBody');
      if (responseBody['status'] == true) {
        // Update successful, handle accordingly
        print('Profile updated successfully');
        print('User ID: ${user.id}');  // Print the user ID here
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileMenuScreen()),
        );
      } else {
        // Update failed, handle accordingly
        print('Failed to update profile: ${responseBody['message']}');
      }
    } else if (response.statusCode == 302) {
      // Handle redirect if necessary
      final redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        final redirectResponse = await http.post(
          Uri.parse(redirectUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'id': user.id,
            'firstname': firstNameController.text,
            'lastname': lastNameController.text,
          }),
        );
        if (redirectResponse.statusCode == 200) {
          final responseBody = jsonDecode(redirectResponse.body);
          if (responseBody['status'] == true) {
            // Update successful, handle accordingly
            print('Profile updated successfully');
            print('User ID: ${user.id}');  // Print the user ID here
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileMenuScreen()),
            );
          } else {
            // Update failed, handle accordingly
            print('Failed to update profile: ${responseBody['message']}');
          }
        } else {
          // HTTP error, handle accordingly
          print('Failed to update profile: ${redirectResponse.statusCode}');
        }
      } else {
        // No redirect location provided
        print('Failed to update profile: No redirect location provided');
      }
    } else {
      // HTTP error, handle accordingly
      print('Failed to update profile: ${response.statusCode}');
    }

  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');

    if (user != null) {
      firstNameController.text = user.firstname ?? '';
      lastNameController.text = user.lastname ?? '';
      emailController.text = user.email ?? '';
      numberController.text = user.mobno != null ? '+974 ${user.mobno}' : '';
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xff124734),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                          fontFamily: 'Aeonik',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/images/profile_pic2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      '${user?.firstname ?? ''} ${user?.lastname ?? ''}',
                      style: const TextStyle(
                          fontFamily: 'Aeonik',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: -0.5,
                          color: Colors.white),
                    ),
                    Text(
                      '+974 ${user?.mobno ?? ''}',
                      style: const TextStyle(
                          fontFamily: 'Aeonik',
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          letterSpacing: -0.5,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    _buildTextField('First Name', 'Enter Your First Name',
                        firstNameController),
                    _buildTextField('Last Name', 'Enter Your Last Name',
                        lastNameController),
                    _buildTextField(
                        'Email', 'Enter Your Email', emailController, false),
                    _buildTextField(
                        'Phone', 'Enter Your Phone number', numberController, false),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
            child: CommonButton(
                text: 'Save changes',
                onTap: () {
                  if (user != null) {
                    updateProfile(user);
                  }
                },
              isLoading: _isLoading,),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String fieldName, String hintText, TextEditingController controller, [bool enabled = true]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
              fontFamily: 'Aeonik',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 32 / 14,
              letterSpacing: -0.41,
              color: Color(0xff124734)),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: enabled ? Colors.white : Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
