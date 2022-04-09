import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:paimon_preview/models/constellations.dart';
import 'package:paimon_preview/models/talents.dart';

import 'boss.dart';

class Character {
  String? id;
  String? name;
  String? tier;
  int? rarity;
  String? weapon;
  String? element;
  String? description;
  String? region;
  String? faction;
  String? image;
  String? quote;
  String? icon;
  String? squareCard;
  String? title;
  String? birthday;
  String? constellation;
  String? chineseVA;
  String? japaneseVA;
  String? englishVA;
  String? koreanVA;
  List<Talents>? talents;
  List<Constellations>? constellations;
  String? roles;
  String? characterOverview;
  Character({
    this.id,
    this.name,
    this.tier,
    this.rarity,
    this.weapon,
    this.element,
    this.description,
    this.region,
    this.faction,
    this.image,
    this.quote,
    this.icon,
    this.squareCard,
    this.title,
    this.birthday,
    this.constellation,
    this.chineseVA,
    this.japaneseVA,
    this.englishVA,
    this.koreanVA,
    this.talents,
    this.constellations,
    this.roles,
    this.characterOverview,
  });

  Character copyWith({
    String? id,
    String? name,
    String? tier,
    int? rarity,
    String? weapon,
    String? element,
    String? description,
    String? region,
    String? faction,
    String? image,
    String? quote,
    String? icon,
    String? squareCard,
    String? title,
    String? birthday,
    String? constellation,
    String? chineseVA,
    String? japaneseVA,
    String? englishVA,
    String? koreanVA,
    List<Talents>? talents,
    List<Constellations>? constellations,
    String? roles,
    String? characterOverview,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      tier: tier ?? this.tier,
      rarity: rarity ?? this.rarity,
      weapon: weapon ?? this.weapon,
      element: element ?? this.element,
      description: description ?? this.description,
      region: region ?? this.region,
      faction: faction ?? this.faction,
      image: image ?? this.image,
      quote: quote ?? this.quote,
      icon: icon ?? this.icon,
      squareCard: squareCard ?? this.squareCard,
      title: title ?? this.title,
      birthday: birthday ?? this.birthday,
      constellation: constellation ?? this.constellation,
      chineseVA: chineseVA ?? this.chineseVA,
      japaneseVA: japaneseVA ?? this.japaneseVA,
      englishVA: englishVA ?? this.englishVA,
      koreanVA: koreanVA ?? this.koreanVA,
      talents: talents ?? this.talents,
      constellations: constellations ?? this.constellations,
      roles: roles ?? this.roles,
      characterOverview: characterOverview ?? this.characterOverview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tier': tier,
      'rarity': rarity,
      'weapon': weapon,
      'element': element,
      'description': description,
      'region': region,
      'faction': faction,
      'image': image,
      'quote': quote,
      'icon': icon,
      'squareCard': squareCard,
      'title': title,
      'birthday': birthday,
      'constellation': constellation,
      'chineseVA': chineseVA,
      'japaneseVA': japaneseVA,
      'englishVA': englishVA,
      'koreanVA': koreanVA,
      'talents': talents?.map((x) => x.toMap()).toList(),
      'constellations': constellations?.map((x) => x.toMap()).toList(),
      'roles': roles,
      'characterOverview': characterOverview,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'],
      name: map['name'],
      tier: map['tier'],
      rarity: map['rarity']?.toInt(),
      weapon: map['weapon'],
      element: map['element'],
      description: map['description'],
      region: map['region'],
      faction: map['faction'],
      image: map['image'],
      quote: map['quote'],
      icon: map['icon'],
      squareCard: map['squareCard'],
      title: map['title'],
      birthday: map['birthday'],
      constellation: map['constellation'],
      chineseVA: map['chineseVA'],
      japaneseVA: map['japaneseVA'],
      englishVA: map['englishVA'],
      koreanVA: map['koreanVA'],
      talents: map['talents'] != null
          ? List<Talents>.from(map['talents']?.map((x) => Talents.fromMap(x)))
          : null,
      constellations: map['constellations'] != null
          ? List<Constellations>.from(
              map['constellations']?.map((x) => Constellations.fromMap(x)))
          : null,
      roles: map['roles'],
      characterOverview: map['characterOverview'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Character(id: $id, name: $name, tier: $tier, rarity: $rarity, weapon: $weapon, element: $element, description: $description, region: $region, faction: $faction, image: $image, quote: $quote, icon: $icon, squareCard: $squareCard, title: $title, birthday: $birthday, constellation: $constellation, chineseVA: $chineseVA, japaneseVA: $japaneseVA, englishVA: $englishVA, koreanVA: $koreanVA, talents: $talents, constellations: $constellations, roles: $roles, characterOverview: $characterOverview)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.tier == tier &&
        other.rarity == rarity &&
        other.weapon == weapon &&
        other.element == element &&
        other.description == description &&
        other.region == region &&
        other.faction == faction &&
        other.image == image &&
        other.quote == quote &&
        other.icon == icon &&
        other.squareCard == squareCard &&
        other.title == title &&
        other.birthday == birthday &&
        other.constellation == constellation &&
        other.chineseVA == chineseVA &&
        other.japaneseVA == japaneseVA &&
        other.englishVA == englishVA &&
        other.koreanVA == koreanVA &&
        listEquals(other.talents, talents) &&
        listEquals(other.constellations, constellations) &&
        other.roles == roles &&
        other.characterOverview == characterOverview;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        tier.hashCode ^
        rarity.hashCode ^
        weapon.hashCode ^
        element.hashCode ^
        description.hashCode ^
        region.hashCode ^
        faction.hashCode ^
        image.hashCode ^
        quote.hashCode ^
        icon.hashCode ^
        squareCard.hashCode ^
        title.hashCode ^
        birthday.hashCode ^
        constellation.hashCode ^
        chineseVA.hashCode ^
        japaneseVA.hashCode ^
        englishVA.hashCode ^
        koreanVA.hashCode ^
        talents.hashCode ^
        constellations.hashCode ^
        roles.hashCode ^
        characterOverview.hashCode;
  }

  static Character bossToChar(Boss unBoss) {
    Character unChar = Character(name: unBoss.name, icon: unBoss.icon);
    return unChar;
  }
}
