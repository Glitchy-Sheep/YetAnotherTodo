import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

abstract interface class TodoRepository {
  Future<List<TaskEntity>> getTodos();
  Future<TaskEntity?> getTodoById(int id);
  Future<void> addTodo(TaskEntity todo);
  Future<void> editTodo(String id, TaskEntity todo);
  Future<TaskEntity?> deleteTodo(String id);
}
