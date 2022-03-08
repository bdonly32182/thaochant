
class FoodModel {
  String foodName;
  double price;
  String imageRef;
  String restaurantId;
  String categoryId;
  String description;
  int status;
  List<String> optionId;
  FoodModel({
    required this.foodName,
    required this.price,
    required this.imageRef,
    required this.restaurantId,
    required this.categoryId,
    required this.description,
    required this.status,
    required this.optionId,
  });

}
