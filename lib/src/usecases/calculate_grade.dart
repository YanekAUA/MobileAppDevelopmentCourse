import '../models/app_state.dart';
import '../core/validators.dart';
import '../core/constants.dart';

/// Pure usecase that calculates the final grade from an [AppState].
///
/// This uses the weighting scheme defined in constants:
/// - Homeworks: 20% (average of 4 slots)
/// - Participation: 10%
/// - Presentation: 10%
/// - Midterm1: 15%
/// - Midterm2: 15%
/// - FinalProject: 30%
double calculateFinalGrade(AppState state) {
  // normalize homeworks to the expected number of slots
  final hwValues = state.homeworks.map((h) => h.score).toList();
  final normalized = normalizeHomeworkList(
    hwValues,
    expectedSlots: homeworkSlotsForFullWeight,
  );
  final hwAvg = normalized.fold(0.0, (a, b) => a + b) / normalized.length;

  final result =
      (hwAvg * weightHomeworks +
          state.participation * weightParticipation +
          state.presentation * weightPresentation +
          state.midterm1 * weightMidterm1 +
          state.midterm2 * weightMidterm2 +
          state.finalProject * weightFinalProject) /
      100.0;

  return clampAndRound(result, minGrade, maxGrade, gradePrecisionDecimals);
}
