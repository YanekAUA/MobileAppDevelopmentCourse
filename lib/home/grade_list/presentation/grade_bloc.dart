import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_4_flutter/home/grade_list/data/grade_repository.dart';
import 'package:homework_4_flutter/home/grade_list/models/grade_list.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_event.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_list_mapper.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_state.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  late GradeList _gradeList;

  final GradeRepository repository;

  GradeBloc(this.repository) : super(InitialGradeState()) {
    on<LoadGradesEvent>((event, emit) async {
      _gradeList = await repository.load();
      emit(_createLoadedState());
    });

    on<ClearGradesEvent>((event, emit) {
      repository.clear();
      _gradeList = GradeList(); // Reset the _gradeList to default values
      repository.save(_gradeList);
      emit(_createLoadedState());
    });

    on<UpdateParticipationEvent>((event, emit) {
      _gradeList.participation = event.value;
      repository.save(_gradeList);
      emit(_createLoadedState());
    });

    on<UpdateGroupPresentationEvent>((event, emit) {
      _gradeList.groupPresentation = event.value;
      repository.save(_gradeList);
      emit(_createLoadedState());
    });

    on<UpdateMidterm1Event>((event, emit) {
      _gradeList.midterm1 = event.value;
      repository.save(_gradeList);
      emit(_createLoadedState());
    });

    on<UpdateMidterm2Event>((event, emit) {
      _gradeList.midterm2 = event.value;
      repository.save(_gradeList);
      emit(_createLoadedState());
    });

    on<UpdateFinalProjectEvent>((event, emit) {
      _gradeList.finalProject = event.value;
      repository.save(_gradeList);
      emit(_createLoadedState());
    });

    on<UpdateHomeworkEvent>((event, emit) {
      if (event.index < _gradeList.homeworks.length) {
        _gradeList.homeworks[event.index] = event.value;
        repository.save(_gradeList);
        emit(_createLoadedState());
      }
    });

    on<AddHomeworkEvent>((event, emit) {
      if (_gradeList.homeworks.length < 10) {
        _gradeList.homeworks.add(100.0);
        repository.save(_gradeList);
        emit(_createLoadedState());
      }
    });

    on<RemoveHomeworkEvent>((event, emit) {
      if (_gradeList.homeworks.length > 1 &&
          event.index < _gradeList.homeworks.length) {
        _gradeList.homeworks.removeAt(event.index);
        repository.save(_gradeList);
        emit(_createLoadedState());
      }
    });

    on<ResetHomeworksEvent>((event, emit) {
      _gradeList.homeworks = List.generate(4, (_) => 100.0);
      repository.save(_gradeList);
      emit(_createLoadedState());
    });
  }

  LoadedGradeState _createLoadedState() {
    final finalGrade = _gradeList.calculateFinalGrade();
    return LoadedGradeState(
      GradeListMapper.toMap(_gradeList),
      List.from(_gradeList.homeworks), // Pass a copy
      finalGrade,
    );
  }
}
