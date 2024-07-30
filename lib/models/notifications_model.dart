import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String message;
  final String date; // Changed from timestamp to date

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'] ?? 'No Timestamp';
    final date = _formatDate(timestamp); // Format the date

    return NotificationModel(
      title: json['title'] ?? 'No Title',
      message: json['message'] ?? 'No Message',
      date: date,
    );
  }

  // Function to format date from timestamp
  static String _formatDate(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final dateFormatter = DateFormat('yyyy-MM-dd'); // Desired format
      return dateFormatter.format(dateTime);
    } catch (e) {
      // Handle parse errors
      print('Error parsing timestamp: $e');
      return 'No Date';
    }
  }
}
