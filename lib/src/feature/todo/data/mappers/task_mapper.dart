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
      priority: model.importance,
      changedAt: model.changedAtUnixTimestamp,
      createdAt: model.createdAtUnixTimestamp,
    );
  }

  static TodoModel toModel(TaskEntity entity) {
    return TodoModel(
      id: entity.id,
      text: entity.description,
      importance: entity.priority,
      deadline: entity.finishUntil,
      isDone: entity.isDone,
      color: null,
      createdAtUnixTimestamp: entity.createdAt,
      changedAtUnixTimestamp: entity.changedAt,
      lastUpdatedBy: 'device_id',
    );
  }
}
