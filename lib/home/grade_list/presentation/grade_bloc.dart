import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_4_flutter/home/grade_list/data/grade_repository.dart';
import 'package:homework_4_flutter/home/grade_list/models/grade_list.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_event.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_list_mapper.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_state.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  GradeList _gradeList;

  final GradeRepository repository;

  GradeBloc(this._gradeList, this.repository) : super(InitialGradeState()) {
    on<LoadGradesEvent>((event, emit) async {
      print("LoadGradesEvent received");
      _gradeList = await repository.load();
      emit(LoadedGradeState(GradeListMapper.toMap(_gradeList)));
    });

    on<SaveGradesEvent>((event, emit) {
      print("SaveGradesEvent received with grades: ${event.grades}");
      _gradeList = GradeListMapper.fromMap(event.grades);
      repository.save(_gradeList);
      emit(SavedGradeState());
    });

    on<ClearGradesEvent>((event, emit) {
      print("ClearGradesEvent received");
      repository.clear();
      _gradeList = GradeList(); // Reset the _gradeList to default values
      emit(InitialGradeState());
    });

    on<CalculateFinalGradeEvent>((event, emit) {
      print("CalculateFinalGradeEvent received");
      _gradeList.calculateFinalGrade();
    });

    on<UpdatePresentationEvent>((event, emit) {
      print("UpdatePresentationEvent received with value: ${event.value}");
    });

    on<UpdateHomeworkEvent>((event, emit) {
      print(
        "UpdateHomeworkEvent received for index: ${event.index} with value: ${event.value}",
      );
    });

    on<UpdateGroupPresentationEvent>((event, emit) {
      print("UpdateGroupPresentationEvent received with value: ${event.value}");
    });

    on<UpdateMidterm1Event>((event, emit) {
      print("UpdateMidterm1Event received with value: ${event.value}");
    });

    on<UpdateMidterm2Event>((event, emit) {
      print("UpdateMidterm2Event received with value: ${event.value}");
    });

    on<UpdateFinalProjectEvent>((event, emit) {
      print("UpdateFinalProjectEvent received with value: ${event.value}");
    });
  }
}
