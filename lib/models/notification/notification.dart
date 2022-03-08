
class NotificationModel {
  String recipientId, title, message;
  bool readingStatus;
  NotificationModel({
    required this.message,
    required this.readingStatus,
    required this.recipientId,
    required this.title,
  });
}
