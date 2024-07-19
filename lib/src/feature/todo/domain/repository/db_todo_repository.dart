import '../entities/task_entity.dart';

abstract interface class TodoDbRepository {
  Future<List<TaskEntity>> getTodos();
  Future<TaskEntity?> getTodoById(String id);
  Future<TaskEntity> addTodo(TaskEntity todo);

  Future<void> editTodo(String id, TaskEntity todo);
  Future<void> deleteTodo(String id);
  Future<void> deleteAllTodos();

  Future<int> getRevision();
  Future<void> increaseRevision();
  Future<void> setRevision(int newRevisionValue);
}
