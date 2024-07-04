class Activity {
  final int id;
  final String activityCode;
  final String activityName;
  final String activityDescription;
  final String activityImage;
  final String imageUrl;

  Activity({
    required this.id,
    required this.activityCode,
    required this.activityName,
    required this.activityDescription,
    required this.activityImage,
    required this.imageUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activityCode: json['activitycode'],
      activityName: json['activity_name'],
      activityDescription: json['activity_descrption'],
      activityImage: json['activityimage'],
      imageUrl: json['image_url'],
    );
  }
}
