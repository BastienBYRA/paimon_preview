import 'dart:convert';
import 'package:http/http.dart' as http;

String genshinUrl = "https://impact.moe/api";

class GenshinAPI {
  static getCharacters() async {
    final request = await http.get(
      Uri.parse(genshinUrl + '/characters'),
    );
    return request.body;
  }

  static getSpecificCharacter(String idCharacter) async {
    final request = await http.get(
      Uri.parse(genshinUrl + '/characters/' + idCharacter),
    );
    return request.body;
  }
}
