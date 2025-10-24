abstract class GradeState {}

class InitialGradeState extends GradeState {}

class LoadedGradeState extends GradeState {
  final Map<String, double> grades;

  LoadedGradeState(this.grades);
}

class SavedGradeState extends GradeState {}
