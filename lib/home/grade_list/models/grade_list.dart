/*Create an application to calculate your final grade based on criteria mentioned in Syllabus.
Participation and attendance (10%) (will be graded 0-100)
4 Homework assignments (20%) (each homework will be graded 0-100)
Group Presentation (10%) (will be graded 0-100)
Midterm Exam 1 10% (will be graded 0-100)
Midterm Exam 2 20% (will be graded 0-100)
Final Project (30%) (will be graded 0-100)
Screenshot attached as a sample, feel free to change UI ( and create better one :) 
By Default all values are 100 and user can change any value, when user tap CALCULATE result should be calculated and shown, user can add 4 homework grades, and reset added homework grades.
To get a 100 grade.
Language Dart only.
Correct working solution without crashes, with handled edge cases.
High quality of code.
It is beneficial,
 to create a little bit complex UI component for homework with add/remove buttons.
To save results in memory (Database, File, Preferences), the user will not need to input values after killing and reopening the application. (shared_preferences*/

class GradeList {
  double participation;
  List<double> homeworks;
  double groupPresentation;
  double midterm1;
  double midterm2;
  double finalProject;
  double? finalGrade;

  GradeList({
    this.participation = 100.0,
    List<double>? homeworks,
    this.groupPresentation = 100.0,
    this.midterm1 = 100.0,
    this.midterm2 = 100.0,
    this.finalProject = 100.0,
    this.finalGrade,
  }) : homeworks = homeworks ?? List.generate(4, (_) => 100.0);

  /// Calculates the final grade based on the current grades.
  double calculateFinalGrade() {
    final double participationScore = participation;
    final double homeworkScore = (homeworks.isNotEmpty)
        ? homeworks.reduce((a, b) => a + b) / homeworks.length
        : 0.0;
    final double groupPresentationScore = groupPresentation;
    final double midterm1Score = midterm1;
    final double midterm2Score = midterm2;
    final double finalProjectScore = finalProject;

    finalGrade =
        (participationScore * 0.10) +
        (homeworkScore * 0.20) +
        (groupPresentationScore * 0.10) +
        (midterm1Score * 0.10) +
        (midterm2Score * 0.20) +
        (finalProjectScore * 0.30);

    return finalGrade!;
  }

  Map<String, dynamic> toJson() {
    return {
      'participation': participation,
      'homeworks': homeworks,
      'groupPresentation': groupPresentation,
      'midterm1': midterm1,
      'midterm2': midterm2,
      'finalProject': finalProject,
      'finalGrade': finalGrade,
    };
  }

  factory GradeList.fromJson(Map<String, dynamic> json) {
    final gradeList = GradeList(
      participation: (json['participation'] as num?)?.toDouble() ?? 100.0,
      homeworks:
          (json['homeworks'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          List.generate(4, (_) => 100.0),
      groupPresentation:
          (json['groupPresentation'] as num?)?.toDouble() ?? 100.0,
      midterm1: (json['midterm1'] as num?)?.toDouble() ?? 100.0,
      midterm2: (json['midterm2'] as num?)?.toDouble() ?? 100.0,
      finalProject: (json['finalProject'] as num?)?.toDouble() ?? 100.0,
    );
    gradeList.calculateFinalGrade();
    return gradeList;
  }
}
