// lib/services/coupon_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coupon_model.dart';

Future<List<Coupon>> fetchCoupons() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('bearerToken');
  final url = Uri.parse('https://interfuel.qa/packupadmin/api/all-coupon');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print('Request URL: ${url.toString()}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> couponsJson = data['data'] ?? [];
    final List<Coupon> allCoupons = couponsJson.map((json) => Coupon.fromJson(json)).toList();

    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime currentDate = DateTime.now();

    final List<Coupon> validCoupons = allCoupons.where((coupon) {
      final DateTime expiryDate = dateFormat.parse(coupon.expiry);
      return expiryDate.isAfter(currentDate);
    }).toList();

    return validCoupons;
  } else {
    throw Exception('Failed to load coupons. Status code: ${response.statusCode}');
  }
}
