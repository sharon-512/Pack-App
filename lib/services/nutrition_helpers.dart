import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'api.dart';


void initializeDailySelections(DateTime start, DateTime end, List<Map<String, dynamic>> dailySelections) {
  int days = calculateDaysDifference(start, end);
  for (int i = 0; i <= days; i++) {
    DateTime currentDate = start.add(Duration(days: i));
    if (currentDate.weekday != DateTime.friday) {
      dailySelections.add({
        'date': currentDate,
        'breakfast': null,
        'lunch': null,
        'snacks': null,
        'dinner': null,
        'addons': []
      });
    }
  }
}

int calculateDaysDifference(DateTime start, DateTime end) {
  return end.difference(start).inDays;
}

Future<void> fetchFoodDetails(int subplanId, int mealtypeId, Function setState) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/get-diet-data'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      Map<String, dynamic>? selectedSubplan;
      for (var plan in data['plan']) {
        for (var subplan in plan['sub_plans']) {
          if (subplan['subplan_id'] == subplanId) {
            selectedSubplan = subplan;
            break;
          }
        }
        if (selectedSubplan != null) break;
      }

      if (selectedSubplan != null) {
        Map<String, dynamic>? selectedMealType;
        for (var mealType in selectedSubplan['meal_plan']) {
          if (mealType['mealtype_id'] == mealtypeId) {
            selectedMealType = mealType;
            break;
          }
        }

        if (selectedMealType != null) {
          setState(() {
            selectedMealType?['products'];
          });
        } else {
          throw Exception('Selected meal type not found');
        }
      } else {
        throw Exception('Selected subplan not found');
      }
    } else {
      throw Exception('Failed to load food details: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching food details: $e');
  }
}

Future<void> fetchAddons(Function setState) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/addons'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        data['data'];
      });
    } else {
      throw Exception('Failed to load addons: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching addons: $e');
  }
}
