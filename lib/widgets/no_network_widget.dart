import 'package:flutter/material.dart';

class NoNetworkWidget extends StatelessWidget {
  const NoNetworkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Your network is lost, please retry',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
