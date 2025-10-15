import '../models/homework.dart';

class HomeworkState {
  final List<Homework> items;
  const HomeworkState({this.items = const []});

  HomeworkState copyWith({List<Homework>? items}) =>
      HomeworkState(items: items ?? this.items);
}
