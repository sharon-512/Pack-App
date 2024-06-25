import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: false, titleText: 'Notification'),
          Expanded(
            child: ListView(
              children: [
                notificationCard(
                  imagePath: 'assets/images/apple.png',
                  title: 'Healthy Eating Tip',
                  message:
                      'Incorporate more greens into your lunch for better digestion.',
                  timestamp: '2 hours ago',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(),
                ),
                notificationCard(
                  imagePath: 'assets/images/apple.png',
                  title: 'Special Discount Just for You!',
                  message: 'Get 20% off on your next order. Use code HEALTHY20.',
                  timestamp: '1 day ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationCard({
    required String imagePath,
    required String title,
    required String message,
    required String timestamp,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF5FBD3)
          ),
          child: Image.asset(imagePath)
        ),
        title: Text(title,
            style: CustomTextStyles.labelTextStyle
        ),
        subtitle: Text(message,
            style: CustomTextStyles.labelTextStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w300
            )
        ),
        trailing: Text(timestamp,style: CustomTextStyles.hintTextStyle.copyWith(fontSize: 12),),
      ),
    );
  }
}
