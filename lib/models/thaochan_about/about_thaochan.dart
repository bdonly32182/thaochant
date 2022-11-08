class AboutThaoChanModel {
  String imageURL;
  String introduce;
  String contact;
  AboutThaoChanModel({
    required this.imageURL,
    required this.introduce,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL,
      'introduce': introduce,
      'contact': contact,
    };
  }

  factory AboutThaoChanModel.fromMap(Map<String, dynamic> map) {
    return AboutThaoChanModel(
      imageURL: map['imageURL'] ?? '',
      introduce: map['introduce'] ?? '',
      contact: map['contact'] ?? '',
    );
  }

}
