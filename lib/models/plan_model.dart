import 'dart:convert';
import 'package:http/http.dart' as http;

class Plan {
  final int planId;
  final String planName;
  final String planImage;

  Plan({required this.planId, required this.planName, required this.planImage});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json['plan_id'],
      planName: json['plan_name'],
      planImage: json['plan_image'],
    );
  }
}

Future<List<Plan>> fetchPlans() async {
  final response = await http.get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<dynamic> planList = data['plan'];
    return planList.map((plan) => Plan.fromJson(plan)).toList();
  } else {
    throw Exception('Failed to load plans');
  }
}
