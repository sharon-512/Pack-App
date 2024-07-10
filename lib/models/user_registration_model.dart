// models/user.dart
class UserRegistrationModel {
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? height;
  String? weight;
  String? age;
  String? gender;
  String? activityLevel;
  String? foodAvoid;

  UserRegistrationModel({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.activityLevel,
    this.foodAvoid,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile_number': mobileNumber,
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'activitylevel': activityLevel,
      'foodavoid': foodAvoid,
    };
  }
}
