import 'dart:ui';

import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xff124734);

class CustomTextStyles {
  static TextStyle titleTextStyle = const TextStyle(
    color: Colors.black,
    fontFamily: 'Aeonik',
    fontWeight: FontWeight.w700,
    fontSize: 34.0,
    height: 1,
    letterSpacing: -0.41,
  );

  static TextStyle subtitleTextStyle = const TextStyle(
    color: Color(0xffBEBEBE),
    fontFamily: 'Aeonik',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    height: 23/16,
    letterSpacing: 1,
  );
  static TextStyle labelTextStyle = const TextStyle(
    fontFamily: 'Aeonik',
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    letterSpacing: -0.41,
  );

  static TextStyle hintTextStyle = const TextStyle(
    color: Color(0xffD8D8D8),
    fontFamily: 'Aeonik',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    height: 1,
    letterSpacing: -0.41,
  );

  static TextStyle informationText = const TextStyle(
    fontFamily: 'Aeonik',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    height: 1.2,
    letterSpacing: -0.2,
  );

}