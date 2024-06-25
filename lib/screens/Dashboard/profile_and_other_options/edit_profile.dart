import 'package:flutter/material.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/common_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  TextEditingController firstNameController = TextEditingController(text: "Mariam");
  TextEditingController lastNameController = TextEditingController(text: "Ahmed");
  TextEditingController emailController = TextEditingController(text: "mariamahmed021@gmail.com");
  TextEditingController numberController = TextEditingController(text: "+974 3344 5566");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xff124734),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    const Text('My Profile',
                      style: TextStyle(
                          fontFamily: 'Aeonik',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 12,),
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
                        color: Colors.white
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
              ),
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32),
                    _buildTextField('First Name', 'Enter Your First Name', firstNameController),
                    _buildTextField('Last Name', 'Enter Your Last Name', lastNameController),
                    _buildTextField('Email', 'Enter Your Email', emailController),
                    _buildTextField('Phone', 'Enter Your Phone number', numberController),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
            child: CommonButton(text: 'Save changes', onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String fieldName, String hintText, TextEditingController contoller) {
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
            color: Color(0xff124734)
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                  hintText: hintText,
                  controller: contoller),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}