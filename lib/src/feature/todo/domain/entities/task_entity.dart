import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';

/// Entity representing a task
/// which can be done or undone ([isDone])
/// and has a [description] that can be edited
/// each [TaskEntity] can have an optional [finishUntil]
@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    // For reordering in the list
    required String id,
    required String description,
    required bool isDone,
    DateTime? finishUntil,
    @Default(TaskPriority.none) TaskPriority priority,
  }) = _TaskEntity;
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
