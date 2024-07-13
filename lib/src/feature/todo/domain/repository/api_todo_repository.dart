import '../entities/task_entity.dart';

abstract interface class TodoApiRepository {
  Future<List<TaskEntity>> getTodos();
  Future<TaskEntity?> getTodoById(String id);

  Future<void> addTodo(TaskEntity todo);
  Future<void> editTodo(String id, TaskEntity todo);
  Future<void> deleteTodo(String id);
}
