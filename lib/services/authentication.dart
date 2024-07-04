import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationService {
  static const String baseUrl = 'https://interfuel.qa/packupadmin/api';

  Future<Map<String, dynamic>> sendMobileNumber(String mobileNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sent-mobile-number'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile_number': mobileNumber,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Please enter a valid mobile number');
    }
  }

  Future<Map<String, dynamic>> confirmOtp(String mobileNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/confirm-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile_number': mobileNumber,
        'otp': otp,
      }),
    );
      return jsonDecode(response.body);
  }
}
