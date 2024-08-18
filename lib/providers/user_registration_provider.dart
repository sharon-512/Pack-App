// providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../models/user_registration_model.dart';

class UserProvider extends ChangeNotifier {
  UserRegistrationModel _user = UserRegistrationModel();

  UserRegistrationModel get user => _user;

  void updateUser(UserRegistrationModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateFirstName(String firstName) {
    _user.firstName = firstName;
    notifyListeners();
  }

  void updateLastName(String lastName) {
    _user.lastName = lastName;
    notifyListeners();
  }

  void updateEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void updateMobileNumber(String mobileNumber) {
    _user.mobileNumber = mobileNumber;
    notifyListeners();
  }

  void updateHeight(String height) {
    _user.height = height;
    notifyListeners();
  }

  void updateWeight(String weight) {
    _user.weight = weight;
    notifyListeners();
  }

  void updateAge(String age) {
    _user.age = age;
    notifyListeners();
  }

  void updateGender(String gender) {
    _user.gender = gender;
    notifyListeners();
  }

  void updateActivityLevel(String activityLevel) {
    _user.activityLevel = activityLevel;
    notifyListeners();
  }

  void updateFoodAvoidList(List<String> foodAvoidList) {
    _user.foodAvoid = foodAvoidList.join(', '); // Store as a comma-separated string
    notifyListeners();
  }

  void clearUserData() {
    _user = UserRegistrationModel(); // Reset user data
    notifyListeners();
  }
}
