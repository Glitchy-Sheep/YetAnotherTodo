part of 'todo_bloc.dart';

@freezed
sealed class TodoState with _$TodoState {
  const TodoState._();

  const factory TodoState.initial() = _Initial;
  const factory TodoState.loadingTasks() = _LoadingTasks;
  const factory TodoState.tasksLoaded(List<TaskEntity> tasks) = _TasksLoaded;

  // Notification only states
  // rebuild shouldn't be called on them
  const factory TodoState.syncError(String message) = _SyncError;
  const factory TodoState.syncSuccess() = _SyncSuccess;

  bool get isNotification => this is _SyncError || this is _SyncSuccess;
  bool get isSyncSuccessNotification => this is _SyncSuccess;
  bool get isSyncErrorNotification => this is _SyncSuccess;
}
