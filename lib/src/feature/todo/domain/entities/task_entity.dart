/// Entity representing a task
/// which can be done or undone ([isDone])
/// and has a [description] that can be edited
/// each [TaskEntity] can have an optional [finishUntil]
class TaskEntity {
  // For reordering in the list
  final int id;
  final String description;
  final bool isDone;

  final DateTime? finishUntil;
  final TaskPriority? priority;

  TaskEntity({
    required this.id,
    required this.description,
    required this.isDone,
    this.finishUntil,
    this.priority,
  });
}

/// Priority of the task
enum TaskPriority {
  none,
  low,
  high;

  String get toNameString {
    return switch (this) {
      TaskPriority.none => 'Нет',
      TaskPriority.low => 'Низкий',
      TaskPriority.high => '!! Высокий'
    };
  }
}
