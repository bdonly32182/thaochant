class ReviewModel {
  String userId;
  String businessId;
  String title;
  String message;
  String imageRef;
  DateTime dateTime;
  double point;
  ReviewModel({
    required this.userId,
    required this.businessId,
    required this.title,
    required this.message,
    required this.imageRef,
    required this.dateTime,
    required this.point,
  });
}
