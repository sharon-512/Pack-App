import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../models/notifications_model.dart';
import '../../../services/notifications_api.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: false, titleText: 'Notification'),
          Expanded(
            child: FutureBuilder<List<NotificationModel>>(
              future: ApiService().fetchNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No notifications found'));
                }

                final notifications = snapshot.data!;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return notificationCard(
                      imagePath: 'assets/images/apple.png', // Update this as per your logic
                      title: notification.title,
                      message: notification.message,
                      date: notification.date, // Use 'date' instead of 'timestamp'
                    );
                  },
                );
              },
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
    required String date, // Changed to 'date'
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF5FBD3),
          ),
          child: Image.asset(imagePath),
        ),
        title: Text(
          message,
          style: CustomTextStyles.labelTextStyle,
        ),
        trailing: Text(
          date, // Use the formatted date here
          style: CustomTextStyles.hintTextStyle.copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
