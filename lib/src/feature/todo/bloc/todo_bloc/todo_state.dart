part of 'todo_bloc.dart';

@freezed
sealed class TodoState with _$TodoState {
  const factory TodoState.initial() = _Initial;
  const factory TodoState.loadingTasks() = _LoadingTasks;
  const factory TodoState.tasksLoaded(List<TaskEntity> tasks) = _TasksLoaded;
  const factory TodoState.error(String message) = _Error;
}
