import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';
import '../core/constants.dart';
import 'grade_repository.dart';

/// Implementation of GradeRepository using SharedPreferences.
class GradeRepositoryImpl implements GradeRepository {
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance.
  /// Call this before using the repository.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<AppState?> load() async {
    if (_prefs == null) {
      await init();
    }

    try {
      final jsonStr = _prefs?.getString(storageKeyAppState);
      if (jsonStr == null || jsonStr.isEmpty) {
        return null;
      }

      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return AppState.fromJson(map);
    } catch (e) {
      // Log error in production, return null for now
      return null;
    }
  }

  @override
  Future<bool> save(AppState state) async {
    if (_prefs == null) {
      await init();
    }

    try {
      final jsonStr = json.encode(state.toJson());
      return await _prefs?.setString(storageKeyAppState, jsonStr) ?? false;
    } catch (e) {
      // Log error in production
      return false;
    }
  }

  @override
  Future<bool> clear() async {
    if (_prefs == null) {
      await init();
    }

    try {
      return await _prefs?.remove(storageKeyAppState) ?? false;
    } catch (e) {
      return false;
    }
  }
}
