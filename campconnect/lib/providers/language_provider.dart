import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Json Languages Read
Future<List<String>> fetchLanguages() async {
  final String response = await rootBundle.loadString('assets/data/lang.json');
  final data = json.decode(response);
  List<String> languages = [];
  for (var language in data) {
    languages.add(language['name']);
  }
  return languages;
}

final languagesProvider = FutureProvider<List<String>>((ref) async {
  return await fetchLanguages();
});
