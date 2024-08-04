import 'package:flutter/material.dart';
import 'package:pack_app/screens/Dashboard/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../screens/onboarding/start_screen.dart';

class ImageSequenceAnimation extends StatefulWidget {
  @override
  _ImageSequenceAnimationState createState() => _ImageSequenceAnimationState();
}

class _ImageSequenceAnimationState extends State<ImageSequenceAnimation> {
  late final Timer timer;
  final List<String> imagePaths = [
    'assets/images/animation1.png',
    'assets/images/animation2.png',
    'assets/images/animation3.png',
    'assets/images/animation4.png',
    'assets/images/animation5.png',
    'assets/images/animation6.png',
    'assets/images/animation7.png',
    'assets/images/animation8.png',
    'assets/images/animation9.png',
  ];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_index == imagePaths.length - 1) {
          timer.cancel();
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StartScreen()));
          });
        } else {
          _index = (_index + 1) % imagePaths.length;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300), // Adjust cross-fade duration
          child: Image.asset(
            imagePaths[_index],
            key: ValueKey<int>(_index),
          ),
        ),
      ),
    );
  }
}
