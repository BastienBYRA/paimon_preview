import 'dart:convert';

class Talents {
  String? id;
  String? name;
  String? description;
  String? image;
  String? type;
  Talents({
    this.id,
    this.name,
    this.description,
    this.image,
    this.type,
  });

  Talents copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? type,
  }) {
    return Talents(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'type': type,
    };
  }

  factory Talents.fromMap(Map<String, dynamic> map) {
    return Talents(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Talents.fromJson(String source) =>
      Talents.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Talents(id: $id, name: $name, description: $description, image: $image, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Talents &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.image == image &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        type.hashCode;
  }
}
