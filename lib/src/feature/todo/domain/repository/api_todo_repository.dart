import '../entities/all_remote_tasks_entity.dart';
import '../entities/task_entity.dart';

abstract interface class TodoApiRepository {
  Future<AllRemoteTasksEntity> getTodos();
  Future<TaskEntity?> getTodoById(String id);
  Future<List<TaskEntity>> updateAllTodos(List<TaskEntity> todos);

  Future<void> addTodo(TaskEntity todo);
  Future<void> editTodo(String id, TaskEntity todo);
  Future<void> deleteTodo(String id);
}
