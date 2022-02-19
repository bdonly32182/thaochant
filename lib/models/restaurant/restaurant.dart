class RestaurantModel {
  String businessName;
  String sellerId;
  String address;
  double latitude;
  double longitude;
  List dateTime;
  bool statusOpen;
  List policyName;
  List policyDescription;
  String promptPay;
  String phoneNumber;
  String restaurantLink;
  String restaurantImageRef;
  String categoryRestaurant;
  RestaurantModel(
    this.address,
    this.businessName,
    this.dateTime,
    this.latitude,
    this.longitude,
    this.policyDescription,
    this.policyName,
    this.promptPay,
    this.sellerId,
    this.statusOpen,
    this.phoneNumber,
    this.restaurantLink,
    this.restaurantImageRef,
    this.categoryRestaurant,
  );
}
