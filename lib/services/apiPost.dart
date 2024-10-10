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

      List<Map<String, dynamic>> menu = [];
      for (var selection in dailySelections) {
        Map<String, dynamic> dayMenu = {"date": selection['date']};

        // Loop through the dynamic meal categories in each selection
        for (var mealType in selection.keys) {
          if (mealType != 'date') {
            dayMenu[mealType] = selection[mealType];  // Dynamically add the meal type
          }
        }
        menu.add(dayMenu);
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
        'price': price,
        'address': address,
        'street_no': streetNo,
        'building_no': buildingNo,
        'flat_no': flatNo,
        'mobile_no': mobileNo,
        'price': price,
        'delivery_price': deliveryPrice,
        'payment_status': paymentStatus,
        'addon_price': addonPrice
      };

      // Make the POST request with automatic redirection handling
      var apiUrl = '$baseUrl/api/save-order';
      var logger = Logger();
      logger.d('jwt token $token');
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
