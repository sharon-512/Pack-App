import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String firstname;

  @HiveField(3)
  final String lastname;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String mobno;

  @HiveField(6)
  final String? streetaddress;

  @HiveField(7)
  final String? city;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.image,
    required this.mobno,
    this.streetaddress,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      image: json['image'],
      mobno: json['mobno'],
      streetaddress: json['streetaddress'],
      city: json['city'],
    );
  }
}
