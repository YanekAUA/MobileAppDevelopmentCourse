/// Simple intents for the grade presenter.
abstract class GradeIntent {
  const GradeIntent();
}

class UpdateParticipation extends GradeIntent {
  final double value;
  UpdateParticipation(this.value);
}

class AddHomework extends GradeIntent {
  const AddHomework();
}

class RemoveHomework extends GradeIntent {
  final int index;
  RemoveHomework(this.index);
}

class UpdateHomework extends GradeIntent {
  final int index;
  final double value;
  UpdateHomework(this.index, this.value);
}

class UpdatePresentation extends GradeIntent {
  final double value;
  UpdatePresentation(this.value);
}

class UpdateMidterm1 extends GradeIntent {
  final double value;
  UpdateMidterm1(this.value);
}

class UpdateMidterm2 extends GradeIntent {
  final double value;
  UpdateMidterm2(this.value);
}

class UpdateFinalProject extends GradeIntent {
  final double value;
  UpdateFinalProject(this.value);
}

class Calculate extends GradeIntent {
  const Calculate();
}

class ResetHomeworks extends GradeIntent {
  const ResetHomeworks();
}
