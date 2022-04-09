import 'dart:convert';

class Constellations {
  String? id;
  String? name;
  int? order;
  String? description;
  String? image;
  Constellations({
    this.id,
    this.name,
    this.order,
    this.description,
    this.image,
  });

  Constellations copyWith({
    String? id,
    String? name,
    int? order,
    String? description,
    String? image,
  }) {
    return Constellations(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'description': description,
      'image': image,
    };
  }

  factory Constellations.fromMap(Map<String, dynamic> map) {
    return Constellations(
      id: map['id'],
      name: map['name'],
      order: map['order']?.toInt(),
      description: map['description'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Constellations.fromJson(String source) =>
      Constellations.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Constellations(id: $id, name: $name, order: $order, description: $description, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Constellations &&
        other.id == id &&
        other.name == name &&
        other.order == order &&
        other.description == description &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        order.hashCode ^
        description.hashCode ^
        image.hashCode;
  }
}
