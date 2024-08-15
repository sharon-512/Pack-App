import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api.dart';

class AuthenticationService {

  Future<Map<String, dynamic>> sendMobileNumber(String mobileNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/sent-mobile-number'),
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
      Uri.parse('$baseUrl/api/confirm-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile_number': mobileNumber,
        'otp': otp,
      }),
    );

    // Decode the response body to a Map
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    // Pretty print the response
    String prettyResponse = JsonEncoder.withIndent('  ').convert(responseBody);
    print('Full response:');
    _printLongString(prettyResponse);

    return responseBody;
  }

  void _printLongString(String text) {
    const int chunkSize = 800; // Adjust chunk size if needed
    int start = 0;
    while (start < text.length) {
      int end = start + chunkSize;
      if (end > text.length) end = text.length;
      print(text.substring(start, end));
      start = end;
    }
  }


}
