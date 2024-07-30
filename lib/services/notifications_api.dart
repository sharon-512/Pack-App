import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../models/notifications_model.dart';

class ApiService {
  final String baseUrl = 'https://interfuel.qa/packupadmin/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bearerToken');
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/notifications');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response JSON: $data');

      if (data is Map && data.containsKey('data')) {
        final dataContent = data['data'];
        if (dataContent is String) {
          return [
            NotificationModel(
              title: 'Notification', // Default title
              message: dataContent,
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()), // Current date
            )
          ];
        }

        throw Exception('Unexpected data format');
      }

      throw Exception('Unexpected JSON structure');
    } else {
      throw Exception('Failed to load notifications. Status code: ${response.statusCode}');
    }
  }
}
