import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/coupons.dart';

Future<List<Coupon>> fetchCoupons() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('bearerToken');
  final response = await http.post(
    Uri.parse('https://interfuel.qa/packupadmin/api/all-coupon'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Coupon.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load coupons');
  }
}
