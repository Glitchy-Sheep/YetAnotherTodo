part of 'todo_bloc.dart';

@freezed
class TodoEvent with _$TodoEvent {
  const factory TodoEvent.loadTodos() = _LoadTodo;
  const factory TodoEvent.addTodo(TaskEntity todoToAdd) = _AddTodo;
  const factory TodoEvent.deleteTodo(String id) = _DeleteTodo;
  const factory TodoEvent.markTodoAsDone(String id) = _MarkTodoAsDone;
  const factory TodoEvent.markTodoAsUndone(String id) = _MarkTodoAsUndone;
  const factory TodoEvent.editTodo(String id, TaskEntity editedTodo) =
      _EditTodo;
  const factory TodoEvent.syncWithServer() = _SyncWithServer;
}
