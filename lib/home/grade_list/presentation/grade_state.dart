sealed class GradeState {}

final class InitialGradeState extends GradeState {}

class LoadedGradeState extends GradeState {
  final Map<String, double> grades;
  final List<double> homeworks;
  final double? finalGrade;

  LoadedGradeState(this.grades, this.homeworks, this.finalGrade);
}

final class SavedGradeState extends GradeState {}
