class Activity {
  final int id;
  final String activityCode;
  final String activityName;
  final String activityNameAr;
  final String activityDescription;
  final String activityImage;
  final String imageUrl;
  final int status;
  final String createdAt;
  final String updatedAt;

  Activity({
    required this.id,
    required this.activityCode,
    required this.activityName,
    required this.activityNameAr,
    required this.activityDescription,
    required this.activityImage,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activityCode: json['activitycode'],
      activityName: json['activity_name'],
      activityNameAr: json['activity_namear'] ?? 'arabic unavailable',
      activityDescription: json['activity_descrption'],
      activityImage: json['activityimage'],
      imageUrl: json['image_url'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
