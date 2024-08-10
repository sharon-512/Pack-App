import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../models/user_registration_model.dart';
import 'api.dart';

class RegistrationService {

  Future<Map<String, dynamic>> newRegister(UserRegistrationModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/new_register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('512 Response: ${responseBody['message']}');
      // if (responseBody['response_code'] == 3) {
      //   final userBox = Hive.box<User>('userBox');
      //   final user = User.fromJson(responseBody['user']);
      //   await userBox.put('currentUser', user);
      //   print('512 - User created: $user');
      // }
      return responseBody;
    } else {
      return {'response_code': -1, 'message 512': 'Failed to register new user'};
    }
  }
}
