import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/homework.dart';
import 'homework_event.dart';
import 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  HomeworkBloc() : super(const HomeworkState()) {
    on<AddHomework>(_onAddHomework);
    on<ToggleHomeworkCompleted>(_onToggleCompleted);
  }

  void _onAddHomework(AddHomework event, Emitter<HomeworkState> emit) {
    // Ensure the homework has an id; generate if missing using timestamp
    final hw = event.homework.id.isEmpty
        ? event.homework.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          )
        : event.homework;

    final updated = List<Homework>.from(state.items)..add(hw);
    emit(state.copyWith(items: updated));
  }

  void _onToggleCompleted(
    ToggleHomeworkCompleted event,
    Emitter<HomeworkState> emit,
  ) {
    final updated = state.items.map((hw) {
      if (hw.id != event.id) return hw;
      return hw.copyWith(completed: !hw.completed);
    }).toList();
    emit(state.copyWith(items: updated));
  }
}
