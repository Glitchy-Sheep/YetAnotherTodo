// task_mapper.dart

import '../../../../core/database/database_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../models/todo_model.dart';

/// This class is responsible for mapping DataModels from Entity
/// and vice versa, so we can easily use them in different places
class TaskMapper {
  static TaskEntity fromModelToEntity(TodoModel model) {
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

  static TodoModel fromEntityToModel(TaskEntity entity) {
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

  static TaskEntity fromDbModelToEntity(TodoDbModel model) {
    return TaskEntity(
      id: model.id,
      description: model.description,
      isDone: model.isDone,
      finishUntil: model.deadline,
      priority: model.priority,
      changedAt: model.changedAt,
      createdAt: model.createdAt,
    );
  }

  static TodoDbModel fromEntityToDbModel(TaskEntity entity) {
    return TodoDbModel(
      id: entity.id,
      description: entity.description,
      isDone: entity.isDone,
      deadline: entity.finishUntil,
      priority: entity.priority,
      changedAt: entity.changedAt,
      createdAt: entity.createdAt,
    );
  }
}
