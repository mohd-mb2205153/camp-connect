import 'dart:convert';

import 'package:flutter/services.dart';

class CampConnectJsonRepo {
  //Json Languages Read
  Future<List<String>> fetchLanguages() async {
    final String response =
        await rootBundle.loadString('assets/data/lang.json');
    final List data = json.decode(response);
    return data.map((item) => item["name"] as String).toList();
  }

  Future<List<String>> fetchCountries() async {
    final String response =
        await rootBundle.loadString('assets/data/countries.json');
    final List data = json.decode(response);
    return data.map((item) => item["en_short_name"] as String).toList();
  }

  Future<List<String>> fetchStudentEducationLevel() async {
    final String response =
        await rootBundle.loadString('assets/data/education_level.json');
    final data = json.decode(response);
    return List<String>.from(data);
  }

  Future<List<String>> fetchSubjects() async {
    final String response =
        await rootBundle.loadString('assets/data/subjects.json');
    final data = json.decode(response);
    return List<String>.from(data);
  }

  Future<List<String>> fetchTeacherEducationLevel() async {
    final String response =
        await rootBundle.loadString('assets/data/teacher_education_level.json');
    final data = json.decode(response) as Map;
    return (data['concept'] as List)
        .map<String>((e) => e['display'] as String)
        .toList();
  }
}
