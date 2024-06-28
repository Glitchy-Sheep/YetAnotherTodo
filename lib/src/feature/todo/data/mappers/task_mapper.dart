// task_mapper.dart

import 'package:yet_another_todo/src/feature/todo/data/models/todo_model.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

/// This class is responsible for mapping DataModels from Entity
/// and vice versa, so we can easily use them in different places
class TaskMapper {
  static TaskEntity toEntity(TodoModel model) {
    return TaskEntity(
      id: model.id,
      description: model.text,
      isDone: model.isDone,
      finishUntil: model.deadline,
      priority: _mapPriority(model.importance),
    );
  }

  static TodoModel toModel(TaskEntity entity) {
    return TodoModel(
      id: entity.id,
      text: entity.description,
      importance: _mapImportance(entity.priority),
      deadline: entity.finishUntil,
      isDone: entity.isDone,
      color: null,
      createdAtUnixTimestamp: DateTime.now().millisecondsSinceEpoch,
      changedAtUnixTimestamp: DateTime.now().millisecondsSinceEpoch,
      lastUpdatedBy: 'device_id',
    );
  }

  static TaskPriority _mapPriority(String importance) {
    return switch (importance) {
      'low' => TaskPriority.low,
      'important' => TaskPriority.high,
      'basic' => TaskPriority.none,
      _ => TaskPriority.none
    };
  }

  static String _mapImportance(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'low',
      TaskPriority.high => 'important',
      TaskPriority.none => 'basic',
    };
  }
}
