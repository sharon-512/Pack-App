import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer_plan.dart';
import 'api.dart';

class SelectedFoodApi {
  static  String _baseUrl = '$baseUrl/api';
  static  String subscriptionListUrl = '$baseUrl/api/subscription-list';

  Future<CustomerPlan> fetchCustomerPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('bearerToken');

    final response = await http.post(
      Uri.parse('$_baseUrl/view-customer-plan'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CustomerPlan.fromJson(data);
    } else {
      throw Exception('Failed to load customer plan');
    }
  }

  static Future<Map<String, dynamic>> subscriptionDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('bearerToken');

    try {
      final response = await http.post(
        Uri.parse(subscriptionListUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load subscription list. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }
}


