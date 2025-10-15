class Homework {
  final String id;
  final String subject;
  final String title;
  final DateTime dueDate;
  final bool completed;

  Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.dueDate,
    this.completed = false,
  });

  Homework copyWith({
    String? id,
    String? subject,
    String? title,
    DateTime? dueDate,
    bool? completed,
  }) {
    return Homework(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'completed': completed,
  };

  static Homework fromJson(Map<String, dynamic> json) => Homework(
    id: json['id'] as String,
    subject: json['subject'] as String,
    title: json['title'] as String,
    dueDate: DateTime.parse(json['dueDate'] as String),
    completed: json['completed'] as bool,
  );
}
