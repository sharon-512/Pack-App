import 'package:flutter/material.dart';
import 'package:pack_app/screens/Dashboard/nav_bar.dart';
import 'package:pack_app/widgets/Animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff124734)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: ImageSequenceAnimation(),
    );
  }
}