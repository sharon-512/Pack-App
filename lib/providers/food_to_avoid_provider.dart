import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/food_to_avoid_model.dart';
import '../services/api.dart';

class FoodProvider with ChangeNotifier {
  List<Food> _foods = [];
  bool _isLoading = false;

  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;

  Future<void> fetchFoods() async {
    _isLoading = true;
    notifyListeners();

    final url = '$baseUrl/api/foodavoid';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Food> loadedFoods = [];
        for (var food in data['data']) {
          loadedFoods.add(Food.fromJson(food));
        }
        _foods = loadedFoods;
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
