class RoomModel {
  String roomName;
  double price;
  String imageCover;
  List<String> listImageDetail;
  String resortId;
  String categoryId;
  String descriptionRoom;
  int totalRoom;
  double roomSize;
  int totalGuest;
  RoomModel({
    required this.roomName,
    required this.price,
    required this.imageCover,
    required this.listImageDetail,
    required this.resortId,
    required this.categoryId,
    required this.descriptionRoom,
    required this.totalRoom,
    required this.roomSize,
    required this.totalGuest,
  });
}
