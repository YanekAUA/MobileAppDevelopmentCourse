import 'homework_item.dart';

/// Immutable AppState representing the calculator screen.
class AppState {
  final double participation;
  final List<HomeworkItem> homeworks;
  final double presentation;
  final double midterm1;
  final double midterm2;
  final double finalProject;
  final double? finalResult;
  final String? errorMessage;
  final bool isLoading;

  const AppState({
    this.participation = 100.0,
    this.homeworks = const [],
    this.presentation = 100.0,
    this.midterm1 = 100.0,
    this.midterm2 = 100.0,
    this.finalProject = 100.0,
    this.finalResult,
    this.errorMessage,
    this.isLoading = false,
  });

  AppState copyWith({
    double? participation,
    List<HomeworkItem>? homeworks,
    double? presentation,
    double? midterm1,
    double? midterm2,
    double? finalProject,
    double? finalResult,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AppState(
      participation: participation ?? this.participation,
      homeworks: homeworks ?? this.homeworks,
      presentation: presentation ?? this.presentation,
      midterm1: midterm1 ?? this.midterm1,
      midterm2: midterm2 ?? this.midterm2,
      finalProject: finalProject ?? this.finalProject,
      finalResult: finalResult ?? this.finalResult,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toJson() => {
    'participation': participation,
    'homeworks': homeworks.map((h) => h.toJson()).toList(),
    'presentation': presentation,
    'midterm1': midterm1,
    'midterm2': midterm2,
    'finalProject': finalProject,
    'finalResult': finalResult,
    'errorMessage': errorMessage,
    'isLoading': isLoading,
  };

  static AppState fromJson(Map<String, dynamic> json) => AppState(
    participation: (json['participation'] as num?)?.toDouble() ?? 0.0,
    homeworks:
        (json['homeworks'] as List<dynamic>?)
            ?.map((e) => HomeworkItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    presentation: (json['presentation'] as num?)?.toDouble() ?? 0.0,
    midterm1: (json['midterm1'] as num?)?.toDouble() ?? 0.0,
    midterm2: (json['midterm2'] as num?)?.toDouble() ?? 0.0,
    finalProject: (json['finalProject'] as num?)?.toDouble() ?? 0.0,
    finalResult: (json['finalResult'] as num?)?.toDouble(),
    errorMessage: json['errorMessage'] as String?,
    isLoading: json['isLoading'] as bool? ?? false,
  );
}
