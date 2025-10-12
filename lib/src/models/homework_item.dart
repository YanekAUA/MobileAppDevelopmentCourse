/// Simple model representing a homework entry.
class HomeworkItem {
  final double score;

  const HomeworkItem(this.score);

  HomeworkItem copyWith({double? score}) => HomeworkItem(score ?? this.score);

  Map<String, dynamic> toJson() => {'score': score};

  static HomeworkItem fromJson(Map<String, dynamic> json) =>
      HomeworkItem((json['score'] as num).toDouble());
}
