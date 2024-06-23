import 'dart:convert';

import 'package:weight_app/data/models/weight_entry.dart';

class WeightEntriesResponse {
  final List<WeightEntry> weightEntries;
  final int currentPage;
  final int lastPage;

  WeightEntriesResponse({required this.weightEntries, required this.currentPage, required this.lastPage});

  factory WeightEntriesResponse.fromJsonStr(String jsonStr) {
    return WeightEntriesResponse.fromJson(jsonDecode(jsonStr));
  }

  factory WeightEntriesResponse.fromJson(Map<String, dynamic> json) {
    var weightEntriesList = (json['data'] as List).map((item) => WeightEntry.fromJson(item)).toList();
    return WeightEntriesResponse(
      weightEntries: weightEntriesList,
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}