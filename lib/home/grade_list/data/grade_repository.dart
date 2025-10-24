import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/grade_list.dart';

/// Repository for persisting the grade list using SharedPreferences.
///
/// Stores the whole `GradeList` as a JSON string under a single key.
class GradeRepository {
  static const String _prefsKey = 'grade_list_v1';

  /// Loads the saved `GradeList` from SharedPreferences.
  /// If no data exists or the data is invalid, returns sensible defaults
  /// (all 100s for grade parts) to match the app's expected initial state.
  Future<GradeList> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return _defaultGradeList();
    }

    try {
      final Map<String, dynamic> map =
          json.decode(jsonString) as Map<String, dynamic>;
      return GradeList.fromJson(map);
    } catch (e) {
      // If decoding fails for any reason, return defaults instead of throwing.
      return _defaultGradeList();
    }
  }

  /// Saves the provided [gradeList] to SharedPreferences as JSON.
  Future<void> save(GradeList gradeList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(gradeList.toJson());
    await prefs.setString(_prefsKey, jsonString);
  }

  /// Removes the saved grade list from preferences.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  GradeList _defaultGradeList() {
    return GradeList(
      participation: 100.0,
      homeworks: [100.0, 100.0, 100.0, 100.0],
      groupPresentation: 100.0,
      midterm1: 100.0,
      midterm2: 100.0,
      finalProject: 100.0,
      finalGrade: null,
    );
  }
}
