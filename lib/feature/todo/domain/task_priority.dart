enum TaskPriority {
  none,
  low,
  high;

  String get toNameString {
    return switch (this) {
      TaskPriority.none => "Нет",
      TaskPriority.low => "Низкий",
      TaskPriority.high => "!! Высокий"
    };
  }
}
