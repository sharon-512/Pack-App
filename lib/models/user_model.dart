import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? firstname;

  @HiveField(3)
  final String? lastname;

  @HiveField(4)
  final String? image;

  @HiveField(5)
  final String? mobno;

  @HiveField(6)
  final String? address;

  @HiveField(7)
  final String? areaName;

  @HiveField(8)
  final String? height;

  @HiveField(9)
  final String? weight;

  @HiveField(10)
  final String? age;

  @HiveField(11)
  final String? gender;

  User({
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.image,
    this.mobno,
    this.address,
    this.areaName,
    this.height,
    this.weight,
    this.age,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      image: json['image'],
      mobno: json['mobno']?.toString(),
      address: json['address'],
      areaName: json['area_name'],
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}
