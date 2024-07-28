class Coupon {
  final String title;
  final String description;
  final String code;

  Coupon({required this.title, required this.description, required this.code});

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      title: json['title'],
      description: json['description'],
      code: json['code'],
    );
  }
}
