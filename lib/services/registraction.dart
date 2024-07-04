import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class RegistrationService {
  static const String baseUrl = 'https://interfuel.qa/packupadmin/api';

  Future<void> newRegister(String firstName, String email, String mobileNumber, String lastName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/new_register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'email': email,
        'mobile_number': mobileNumber,
        'last_name': lastName,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Response: ${responseBody['message']}');
      if (responseBody['response_code'] == 3) {
        final userBox = Hive.box<User>('userBox');
        final user = User.fromJson(responseBody['user']);
        await userBox.put('currentUser', user);
        print('User created: $user');
      }
    } else {
      print('Failed to register new user');
    }
  }
}
