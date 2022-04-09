import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:paimon_preview/models/character.dart';

class Team {
  List<Character>? listCharacter;
  Team({
    this.listCharacter,
  });

  Team copyWith({
    List<Character>? listCharacter,
  }) {
    return Team(
      listCharacter: listCharacter ?? this.listCharacter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listCharacter': listCharacter?.map((x) => x.toMap()).toList(),
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      listCharacter: map['listCharacter'] != null
          ? List<Character>.from(
              map['listCharacter']?.map((x) => Character.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source));

  @override
  String toString() => 'Team(listCharacter: $listCharacter)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Team && listEquals(other.listCharacter, listCharacter);
  }

  @override
  int get hashCode => listCharacter.hashCode;

  static Team addListCharacter(List<Character> charTeam) {
    Team teamTemp = Team(listCharacter: []);
    for (Character char in charTeam) {
      teamTemp.listCharacter!.add(char);
    }
    return teamTemp;
  }

  static Team addCharacter(Character char) {
    List<Character> listCharTemp = [];
    listCharTemp.add(char);
    Team teamTemp = Team(listCharacter: listCharTemp);
    return teamTemp;
  }
}
