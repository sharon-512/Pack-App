import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/activity_level_model.dart';
import '../services/api.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [];
  bool _isLoading = false;

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;

  Future<void> fetchActivities() async {
    _isLoading = true;
    notifyListeners();

    final url = '$baseUrl/api/activitylevel';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Activity> loadedActivities = [];
        for (var activity in data['data']) {
          loadedActivities.add(Activity.fromJson(activity));
        }
        _activities = loadedActivities;
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
