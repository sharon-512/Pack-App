import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/customer_plan.dart';

class ApiService {
  static const String apiUrl = 'https://interfuel.qa/packupadmin/api/view-customer-plan';

  static Future<CustomerPlan> fetchCustomerPlan(String token) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return CustomerPlan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load customer plan');
    }
  }
}
