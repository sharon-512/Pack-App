import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../models/notifications_model.dart';
import '../../../providers/app_localizations.dart';
import '../../../services/notifications_api.dart';
import '../../../widgets/no_network_widget.dart';

class NotificationsScreen extends StatefulWidget {
   NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

   @override
   void initState() {
     super.initState();
     initConnectivity();
     _connectivitySubscription =
         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
   }

   @override
   void dispose() {
     _connectivitySubscription.cancel();
     super.dispose();
   }

   Future<void> initConnectivity() async {
     late List<ConnectivityResult> result;
     // Platform messages may fail, so we use a try/catch PlatformException.
     try {
       result = await _connectivity.checkConnectivity();
     } on PlatformException catch (e) {
       print('Couldn\'t check connectivity status');
       return;
     }

     // If the widget was removed from the tree while the asynchronous platform
     // message was in flight, we want to discard the reply rather than calling
     // setState to update our non-existent appearance.
     if (!mounted) {
       return Future.value(null);
     }

     return _updateConnectionStatus(result);
   }

   Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
     setState(() {
       _connectionStatus = result;
     });
     if (_connectionStatus.last == ConnectivityResult.none) {
       print('No internet connection');
     } else {
       print('Connected to the internet');
     }
     // ignore: avoid_print
     print('Connectivity changed: $_connectionStatus');
   }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: false, titleText: localizations!.translate('notification'),),
          Expanded(
            child: FutureBuilder<List<NotificationModel>>(
              future: ApiService().fetchNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return  Center(
                    child: Text(localizations!.translate('noNotifications'),
                      textAlign: TextAlign.center,
                    ),);
                    //Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(localizations!.translate('noNotifications'),));
                }

                final notifications = snapshot.data!;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return notificationCard(
                      imagePath: 'assets/images/nav_bar3.svg', // Update this as per your logic
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF5FBD3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(imagePath, color: Colors.blueGrey,),
          ),
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
