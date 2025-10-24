abstract class GradeEvent {}

class LoadGradesEvent extends GradeEvent {}

class SaveGradesEvent extends GradeEvent {
  final Map<String, double> grades;

  SaveGradesEvent(this.grades);
}

class ClearGradesEvent extends GradeEvent {}

class CalculateFinalGradeEvent extends GradeEvent {}

class UpdatePresentationEvent extends GradeEvent {
  final double value;

  UpdatePresentationEvent(this.value);
}

class UpdateHomeworkEvent extends GradeEvent {
  final int index;
  final double value;

  UpdateHomeworkEvent(this.index, this.value);
}

class UpdateGroupPresentationEvent extends GradeEvent {
  final double value;

  UpdateGroupPresentationEvent(this.value);
}

class UpdateMidterm1Event extends GradeEvent {
  final double value;

  UpdateMidterm1Event(this.value);
}

class UpdateMidterm2Event extends GradeEvent {
  final double value;

  UpdateMidterm2Event(this.value);
}

class UpdateFinalProjectEvent extends GradeEvent {
  final double value;

  UpdateFinalProjectEvent(this.value);
}
