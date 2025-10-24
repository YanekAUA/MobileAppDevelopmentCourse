abstract class GradeEvent {}

class LoadGradesEvent extends GradeEvent {}

class ClearGradesEvent extends GradeEvent {}

class UpdateParticipationEvent extends GradeEvent {
  final double value;

  UpdateParticipationEvent(this.value);
}

class UpdateHomeworkEvent extends GradeEvent {
  final int index;
  final double value;

  UpdateHomeworkEvent(this.index, this.value);
}

class AddHomeworkEvent extends GradeEvent {}

class RemoveHomeworkEvent extends GradeEvent {
  final int index;

  RemoveHomeworkEvent(this.index);
}

class ResetHomeworksEvent extends GradeEvent {}

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
