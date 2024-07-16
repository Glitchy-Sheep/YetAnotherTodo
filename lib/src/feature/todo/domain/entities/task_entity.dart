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
    required DateTime createdAt,
    required DateTime changedAt,
    DateTime? finishUntil,
    @Default(TaskPriority.basic) TaskPriority priority,
  }) = _TaskEntity;
}

/// Priority of the task
enum TaskPriority {
  @JsonValue('basic')
  basic,
  @JsonValue('low')
  low,
  @JsonValue('important')
  important;
  // UPDATE IT ONLY TO THE END
  // because it is used by database
  // otherwise you'll need to write migrations:
  // https://drift.simonbinder.eu/docs/advanced-features/type_converters/#implicit-enum-converters
}
