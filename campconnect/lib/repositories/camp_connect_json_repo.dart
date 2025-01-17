import 'dart:convert';

import 'package:flutter/services.dart';

class CampConnectJsonRepo {
  //Json Languages Read
  Future<List<String>> fetchLanguages() async {
    final String response =
        await rootBundle.loadString('assets/data/lang.json');
    final data = json.decode(response);
    List<String> languages = [];
    for (var language in data) {
      languages.add(language['name']);
    }
    return languages;
  }

  Future<List<String>> fetchEducationLevel() async {
    final String response =
        await rootBundle.loadString('assets/data/education_level.json');
    final data = json.decode(response);
    return List<String>.from(data);
  }
}
