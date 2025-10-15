import '../models/homework.dart';

abstract class HomeworkEvent {}

class LoadHomeworks extends HomeworkEvent {}

class AddHomework extends HomeworkEvent {
  final Homework homework;
  AddHomework(this.homework);
}

class ToggleHomeworkCompleted extends HomeworkEvent {
  final String id;
  ToggleHomeworkCompleted(this.id);
}

class RemoveHomework extends HomeworkEvent {
  final String id;
  RemoveHomework(this.id);
}
