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

  const AddressWidget({
    Key? key,
    required this.label,
    this.address = '',
    this.labelStyle = _defaultLabelStyle,
    this.hintStyle = _defaultHintStyle,
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
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff000000).withOpacity(.07)),
            borderRadius: BorderRadius.circular(17),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: address, // Use 'address' as hint text
              hintStyle: hintStyle,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
