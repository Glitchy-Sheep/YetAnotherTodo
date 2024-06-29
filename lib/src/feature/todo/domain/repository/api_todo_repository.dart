import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

abstract interface class TodoRepositoryApi {
  Future<List<TaskEntity>> getTodos();
  Future<TaskEntity?> getTodoById(String id);

  Future<void> addTodo(TaskEntity todo);
  Future<void> editTodo(String id, TaskEntity todo);
  Future<void> deleteTodo(String id);
}
