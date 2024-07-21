import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  }) async {
    try {

      String planFrom = DateFormat('yyyy-MM-dd').format(startDate);
      String planTo = DateFormat('yyyy-MM-dd').format(endDate);

      // Prepare menu from dailySelections
      List<Map<String, dynamic>> menu = [];
      for (var selection in dailySelections) {
        menu.add({
          "date": selection['date'],
          "breakfast": selection['breakfast'],
          "lunch": selection['lunch'],
          "snacks": selection['snacks'],
          "dinner": selection['dinner'],
        });
      }

      List<Map<String, dynamic>> addon = [];
      for (var addonItem in selectedAddons) {
        addon.add({
          "id": addonItem['id'],
          "quantity": addonItem['quantity'],
        });
      }

      // Prepare form data for the POST request
      var formData = {
        'user_id': userId,
        'plan_from': planFrom,
        'plan_to': planTo,
        'product_id': productId,
        'menu': jsonEncode(menu),
        'addon': jsonEncode(addon),
        'address': address,
        'street_no': streetNo,
        'building_no': buildingNo,
        'flat_no': flatNo,
        'mobile_no': mobileNo,
      };

      // Make the POST request with automatic redirection handling
      var apiUrl = 'https://interfuel.qa/packupadmin/api/save-order';
      var response = await http.post(
        Uri.parse(apiUrl),
        body: formData,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      print('Form Data: ${jsonEncode(formData)}'); // Print the JSON structure

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
