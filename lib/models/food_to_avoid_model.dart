class Food {
  final int id;
  final String foodCode;
  final String foodName;
  final String foodImage;
  final String imageUrl;
  final int status;
  final String createdAt;
  final String updatedAt;

  Food({
    required this.id,
    required this.foodCode,
    required this.foodName,
    required this.foodImage,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      foodCode: json['foodcode'],
      foodName: json['food_name'],
      foodImage: json['foodimage'],
      imageUrl: json['image_url'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
