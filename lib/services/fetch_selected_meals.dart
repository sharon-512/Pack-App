import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer_plan.dart';
import '../models/diet_plan.dart';

class SelectedFoodApi {
  static const String _baseUrl = 'https://interfuel.qa/packupadmin/api';

  Future<DietPlan> fetchDietPlan() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get-diet-data'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DietPlan.fromJson(data);
    } else {
      throw Exception('Failed to load diet plan');
    }
  }

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
}
