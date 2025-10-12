import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_state.dart';
import '../models/homework_item.dart';
import '../intents/grade_intent.dart';
import '../usecases/calculate_grade.dart';
import '../repositories/grade_repository.dart';

/// A simple MVI presenter that exposes a ValueNotifier (holding AppState) as
/// the source of truth and accepts intents via [dispatch].
class GradePresenter {
  final _controller = StreamController<GradeIntent>();
  final GradeRepository _repository;

  final stateNotifier = ValueNotifier<AppState>(const AppState());

  GradePresenter(this._repository) {
    _controller.stream.listen(_handleIntent);
    _init();
  }

  Future<void> _init() async {
    // Load saved state
    final savedState = await _repository.load();
    if (savedState != null) {
      stateNotifier.value = savedState;
    }

    // persist whenever state changes
    stateNotifier.addListener(() {
      _repository.save(stateNotifier.value);
    });
  }

  void dispatch(GradeIntent intent) => _controller.add(intent);

  void _handleIntent(GradeIntent intent) {
    final current = stateNotifier.value;
    if (intent is UpdateParticipation) {
      stateNotifier.value = current.copyWith(participation: intent.value);
      return;
    }
    if (intent is AddHomework) {
      final newList = List<HomeworkItem>.from(current.homeworks)
        ..add(const HomeworkItem(100.0));
      stateNotifier.value = current.copyWith(homeworks: newList);
      return;
    }
    if (intent is RemoveHomework) {
      final newList = List<HomeworkItem>.from(current.homeworks);
      if (intent.index >= 0 && intent.index < newList.length) {
        newList.removeAt(intent.index);
        stateNotifier.value = current.copyWith(homeworks: newList);
      }
      return;
    }
    if (intent is UpdateHomework) {
      final newList = List<HomeworkItem>.from(current.homeworks);
      if (intent.index >= 0 && intent.index < newList.length) {
        newList[intent.index] = newList[intent.index].copyWith(
          score: intent.value,
        );
        stateNotifier.value = current.copyWith(homeworks: newList);
      }
      return;
    }
    if (intent is UpdatePresentation) {
      stateNotifier.value = current.copyWith(presentation: intent.value);
      return;
    }
    if (intent is UpdateMidterm1) {
      stateNotifier.value = current.copyWith(midterm1: intent.value);
      return;
    }
    if (intent is UpdateMidterm2) {
      stateNotifier.value = current.copyWith(midterm2: intent.value);
      return;
    }
    if (intent is UpdateFinalProject) {
      stateNotifier.value = current.copyWith(finalProject: intent.value);
      return;
    }
    if (intent is ResetHomeworks) {
      stateNotifier.value = current.copyWith(homeworks: const []);
      return;
    }
    if (intent is Calculate) {
      try {
        final result = calculateFinalGrade(current);
        stateNotifier.value = current.copyWith(
          finalResult: result,
          errorMessage: null,
        );
      } catch (e) {
        stateNotifier.value = current.copyWith(errorMessage: e.toString());
      }
      return;
    }
  }

  void dispose() {
    _controller.close();
    stateNotifier.dispose();
  }
}
