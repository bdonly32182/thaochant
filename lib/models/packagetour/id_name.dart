import 'dart:convert';

class IdAndName {
  String id;
  String name;
  String imageRef;
  IdAndName({
    required this.id,
    required this.name,
    required this.imageRef,
  });
  

  IdAndName copyWith({
    String? id,
    String? name,
    String? imageRef,
  }) {
    return IdAndName(
      id: id ?? this.id,
      name: name ?? this.name,
      imageRef: imageRef ?? this.imageRef,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageRef': imageRef,
    };
  }

  factory IdAndName.fromMap(Map<String, dynamic> map) {
    return IdAndName(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageRef: map['imageRef'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IdAndName.fromJson(String source) => IdAndName.fromMap(json.decode(source));

  @override
  String toString() => 'IdAndName(id: $id, name: $name, imageRef: $imageRef)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is IdAndName &&
      other.id == id &&
      other.name == name &&
      other.imageRef == imageRef;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageRef.hashCode;
}
