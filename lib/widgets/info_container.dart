import 'package:flutter/material.dart';

// Define default text styles
const TextStyle _defaultLabelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  fontFamily: 'Aeonik',
);

const TextStyle _defaultHintStyle = TextStyle(
  fontSize: 14,
  fontFamily: 'Aeonik',
  fontWeight: FontWeight.w400,
  color: Color(0xffB4B4B4),
);

class AddressWidget extends StatelessWidget {
  final String label;
  final String address;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;

  const AddressWidget({
    Key? key,
    required this.label,
    this.address = '',
    this.labelStyle = _defaultLabelStyle,
    this.hintStyle = _defaultHintStyle,
    required this.textEditingController,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Color(0xffB1B1B1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Color(0xffB1B1B1)),
            ),
            hintText: address,
            // Use 'address' as hint text
            hintStyle: hintStyle,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          ),
          controller: textEditingController,
          validator: validator,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
