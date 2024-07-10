import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pack_app/models/user_model.dart';

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('No user data found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${user.id}'),
              SizedBox(height: 8),
              Text('Email: ${user.email}'),
              SizedBox(height: 8),
              Text('First Name: ${user.firstname}'),
              SizedBox(height: 8),
              Text('Last Name: ${user.lastname}'),
              SizedBox(height: 8),
              Text('Mobile Number: ${user.mobno}'),
              SizedBox(height: 8),
              Text('Address: ${user.address ?? 'N/A'}'),
              SizedBox(height: 8),
              Text('Area Name: ${user.areaName ?? 'N/A'}'),
              SizedBox(height: 8),
              Text('Height: ${user.height?.toString() ?? 'N/A'}'),
              SizedBox(height: 8),
              Text('Weight: ${user.weight?.toString() ?? 'N/A'}'),
              SizedBox(height: 8),
              Text('Age: ${user.age?.toString() ?? 'N/A'}'),
              SizedBox(height: 8),
              Text('Gender: ${user.gender ?? 'N/A'}'),
              SizedBox(height: 8),
              Image.network(
                user.image!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
