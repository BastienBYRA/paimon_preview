import 'dart:convert';

import 'package:paimon_preview/models/character.dart';

class Boss {
  int? id;
  String? name;
  String? icon;
  String? location;
  String? image;
  String? map;
  Boss({
    this.id,
    this.name,
    this.icon,
    this.location,
    this.image,
    this.map,
  });

  Boss copyWith({
    int? id,
    String? name,
    String? icon,
    String? location,
    String? image,
    String? map,
  }) {
    return Boss(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      location: location ?? this.location,
      image: image ?? this.image,
      map: map ?? this.map,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'location': location,
      'image': image,
      'map': map,
    };
  }

  factory Boss.fromMap(Map<String, dynamic> map) {
    return Boss(
      id: map['id']?.toInt(),
      name: map['name'],
      icon: map['icon'],
      location: map['location'],
      image: map['image'],
      map: map['map'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Boss.fromJson(String source) => Boss.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Boss(id: $id, name: $name, icon: $icon, location: $location, image: $image, map: $map)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Boss &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.location == location &&
        other.image == image &&
        other.map == map;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        icon.hashCode ^
        location.hashCode ^
        image.hashCode ^
        map.hashCode;
  }

  Character bossToCharacter() {
    Character char = Character(name: name, icon: icon);
    return char;
  }
}
