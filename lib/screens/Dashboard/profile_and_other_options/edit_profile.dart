import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pack_app/screens/Dashboard/profile_and_other_options/profile_page.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../models/user_model.dart';
import '../nav_bar.dart';

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
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> updateProfile(User user) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('bearerToken');
    final url = Uri.parse(
        'https://interfuel.qa/packupadmin/api/update-profile?id=${user.id}&firstname=${firstNameController.text}&lastname=${lastNameController.text}');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['id'] = user.id.toString()
      ..fields['firstname'] = firstNameController.text
      ..fields['lastname'] = lastNameController.text;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      print('Response JSON: $jsonResponse');
      if (jsonResponse['status'] == true) {
        // Update successful, update the Hive model
        final userBox = Hive.box<User>('userBox');
        final updatedUser = User(
          id: user.id,
          email: emailController.text,
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          image: _image?.path ?? user.image,
          mobno: user.mobno,
          address: user.address,
          areaName: user.areaName,
          height: user.height,
          weight: user.weight,
          age: user.age,
          gender: user.gender,
        );
        userBox.put('currentUser', updatedUser);
        print('Profile updated successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar(selectedIndex: 4)),
        );
      } else {
        // Update failed, handle accordingly
        print('Failed to update profile: ${jsonResponse['message']}');
      }

    } else {
      // HTTP error, handle accordingly
      print('Failed to update profile: ${response.statusCode}');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');

    if (user != null) {
      firstNameController.text = firstNameController.text.isEmpty ? user.firstname ?? '' : firstNameController.text;
      lastNameController.text = lastNameController.text.isEmpty ? user.lastname ?? '' : lastNameController.text;
      emailController.text = emailController.text.isEmpty ? user.email ?? '' : emailController.text;
      numberController.text = numberController.text.isEmpty ? (user.mobno != null ? '+974 ${user.mobno}' : '') : numberController.text;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => BottomSheet(
                              onClosing: () {},
                              builder: (context) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.photo),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : (user?.image != null
                              ? FileImage(File(user!.image!))
                              : const AssetImage('assets/images/profile_place_holder.jpg'))
                          as ImageProvider,
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
                      _buildTextField('First Name', 'Enter Your First Name', firstNameController),
                      _buildTextField('Last Name', 'Enter Your Last Name', lastNameController),
                      _buildTextField('Email', 'Enter Your Email', emailController, false),
                      _buildTextField('Phone', 'Enter Your Phone number', numberController, false),
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
      ),
    );
  }

  Widget _buildTextField(String fieldName, String hintText, TextEditingController controller, [bool enabled = true]) {
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
