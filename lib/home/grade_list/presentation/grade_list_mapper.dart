import 'package:homework_4_flutter/home/grade_list/models/grade_list.dart';

class GradeListMapper {
  /// Converts a `GradeList` to a `Map<String, double>` for easier UI consumption.
  static Map<String, double> toMap(GradeList gradeList) {
    final Map<String, double> gradeMap = {};
    gradeMap['participation'] = gradeList.participation ?? 100.0;
    gradeMap['homeworks'] =
        gradeList.homeworks != null && gradeList.homeworks!.isNotEmpty
        ? gradeList.homeworks!.reduce((a, b) => a + b) /
              gradeList.homeworks!.length
        : 100.0;
    gradeMap['groupPresentation'] = gradeList.groupPresentation ?? 100.0;
    gradeMap['midterm1'] = gradeList.midterm1 ?? 100.0;
    gradeMap['midterm2'] = gradeList.midterm2 ?? 100.0;
    gradeMap['finalProject'] = gradeList.finalProject ?? 100.0;
    gradeMap['finalGrade'] = gradeList.finalGrade ?? 100.0;
    return gradeMap;
  }

  /// Converts a `Map<String, double>` back to a `GradeList`.
  static GradeList fromMap(Map<String, double> gradeMap) {
    return GradeList(
      participation: gradeMap['participation'] ?? 100.0,
      homeworks: [gradeMap['homeworks'] ?? 100.0],
      groupPresentation: gradeMap['groupPresentation'] ?? 100.0,
      midterm1: gradeMap['midterm1'] ?? 100.0,
      midterm2: gradeMap['midterm2'] ?? 100.0,
      finalProject: gradeMap['finalProject'] ?? 100.0,
      finalGrade: gradeMap['finalGrade'] ?? 100.0,
    );
  }
}
