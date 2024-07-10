import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';

class CommonTextField extends StatelessWidget {
  CommonTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.isEditable = true, // Added parameter for editability
    this.validator, // Added parameter for validation
  });

  final String hintText;
  final TextEditingController controller;
  TextInputType? keyboardType = TextInputType.text;
  final bool isEditable; // Added property for editability
  final FormFieldValidator<String>? validator; // Added property for validation

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEDC0B2)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEDC0B2)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hintText,
        hintStyle: CustomTextStyles.hintTextStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
      ),
      keyboardType: keyboardType,
      readOnly: !isEditable, // Use the isEditable flag to control editability
      validator: validator, // Use the validator parameter
    );
  }
}
