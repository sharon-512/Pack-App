import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'api.dart';

class ApiService {
  static Future<Map<String, dynamic>> placeOrder({
    required String userId,
    required String token,
    required DateTime startDate,
    required DateTime endDate,
    required String productId,
    required List<Map<String, dynamic>> dailySelections,
    required List<Map<String, dynamic>> selectedAddons,
    required String address,
    required String streetNo,
    required String buildingNo,
    required String flatNo,
    required String mobileNo,
    required String price,
    required String addonPrice,
    required String deliveryPrice,
    required String paymentStatus,
  }) async {
    try {
      String planFrom = DateFormat('yyyy-MM-dd').format(startDate);
      String planTo = DateFormat('yyyy-MM-dd').format(endDate);

      // Prepare menu data
      List<Map<String, dynamic>> menu = [];
      for (var selection in dailySelections) {
        Map<String, dynamic> dayMenu = {"date": selection['date']};
        for (var mealType in selection.keys) {
          if (mealType != 'date') {
            dayMenu[mealType.toLowerCase()] = selection[mealType];
          }
        }
        menu.add(dayMenu);
      }

      // Prepare addon data
      List<Map<String, dynamic>> addon = [];
      for (var addonItem in selectedAddons) {
        Map<String, dynamic> lowerCaseAddon = {
          "id": addonItem['id'],
          "quantity": addonItem['quantity'],
        };
        addon.add(lowerCaseAddon);
      }

      // Build the request body as JSON
      Map<String, dynamic> body = {
        "plan_from": planFrom,
        "plan_to": planTo,
        "product_id": productId,
        "menu": jsonEncode(menu),
        "addon": jsonEncode(addon),
        "price": price,
        "delivery_price": deliveryPrice,
      };

      var logger = Logger();
      logger.d('Sending request with token: $token');
      logger.d('Sending request with body: $body');

      // Send the POST request with JSON data
      var response = await http.post(
        Uri.parse('$baseUrl/api/save-order'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8', // Ensure Content-Type is set
        },
        body: jsonEncode(body),
      );

      // Handle response
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': response.body};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
