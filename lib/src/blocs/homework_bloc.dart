import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/homework.dart';
import 'homework_event.dart';
import 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  HomeworkBloc() : super(const HomeworkState()) {
    on<LoadHomeworks>(_onLoadHomeworks);
    on<AddHomework>(_onAddHomework);
    on<RemoveHomework>(_onRemoveHomework);
    on<ToggleHomeworkCompleted>(_onToggleCompleted);

    // trigger loading from persistence
    add(LoadHomeworks());
  }

  Future<void> _onLoadHomeworks(
    LoadHomeworks event,
    Emitter<HomeworkState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('homework_items');
    if (jsonString == null || jsonString.isEmpty) return;
    try {
      final list = json.decode(jsonString) as List<dynamic>;
      final items = list
          .map((e) => Homework.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      emit(state.copyWith(items: items));
    } catch (_) {
      // ignore parse errors
    }
  }

  void _onAddHomework(AddHomework event, Emitter<HomeworkState> emit) {
    final hw = event.homework.id.isEmpty
        ? event.homework.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          )
        : event.homework;

    final updated = List<Homework>.from(state.items)..add(hw);
    final newState = state.copyWith(items: updated);
    emit(newState);
    _saveItems(newState.items);
  }

  void _onToggleCompleted(
    ToggleHomeworkCompleted event,
    Emitter<HomeworkState> emit,
  ) {
    final updated = state.items.map((hw) {
      if (hw.id != event.id) return hw;
      return hw.copyWith(completed: !hw.completed);
    }).toList();
    final newState = state.copyWith(items: updated);
    emit(newState);
    _saveItems(newState.items);
  }

  Future<void> _saveItems(List<Homework> items) async {
    final prefs = await SharedPreferences.getInstance();
    final list = items.map((e) => e.toJson()).toList();
    await prefs.setString('homework_items', json.encode(list));
  }

  void _onRemoveHomework(RemoveHomework event, Emitter<HomeworkState> emit) {
    final updated = state.items.where((hw) => hw.id != event.id).toList();
    final newState = state.copyWith(items: updated);
    emit(newState);
    _saveItems(newState.items);
  }
}
