import '../models/app_state.dart';

/// Repository interface for persisting and loading AppState.
/// This abstraction allows easy testing and swapping of storage implementations
/// (SharedPreferences, Hive, file-based, etc.).
abstract class GradeRepository {
  /// Load the saved AppState from persistent storage.
  /// Returns null if no saved state exists or if loading fails.
  Future<AppState?> load();

  /// Save the current AppState to persistent storage.
  /// Returns true if successful, false otherwise.
  Future<bool> save(AppState state);

  /// Clear all saved data.
  Future<bool> clear();
}
