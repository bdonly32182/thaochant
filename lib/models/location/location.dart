class LocationModel {
  String locationName;
  String address; 
  String description;
  List<String> imageList; 
  String videoRef;
  num ratingCount;
  num point;
  double lat;
  double lng;
  LocationModel({
    required this.locationName,
    required this.address,
    required this.description,
    required this.imageList,
    required this.videoRef,
    required this.ratingCount,
    required this.point,
    required this.lat,
    required this.lng,
  });
  
}
