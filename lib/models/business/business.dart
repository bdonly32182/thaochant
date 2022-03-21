class BusinessModel {
  String businessName;
  String sellerId;
  String address;
  double latitude;
  double longitude;
  int statusOpen;
  num ratingCount;
  num point;
  List<dynamic> policyName;
  List<dynamic> policyDescription;
  String promptPay;
  String phoneNumber;
  String link;
  String imageRef;
  BusinessModel(
    this.address,
    this.businessName,
    this.latitude,
    this.longitude,
    this.policyDescription,
    this.policyName,
    this.promptPay,
    this.sellerId,
    this.statusOpen,
    this.phoneNumber,
    this.link,
    this.imageRef,
    this.point,
    this.ratingCount,
  );
}
