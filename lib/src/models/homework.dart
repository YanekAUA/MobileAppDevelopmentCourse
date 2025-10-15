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
}
