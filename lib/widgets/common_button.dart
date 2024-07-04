import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../custom_style.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const CommonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey[300] : primaryGreen,
          borderRadius: BorderRadius.circular(46),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : Text(
          text,
          style: TextStyle(
            fontFamily: 'Aeonik',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
