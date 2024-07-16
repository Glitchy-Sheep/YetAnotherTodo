import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/tools/tools.dart';
import '../../../app/app_settings.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/api_todo_repository.dart';
import '../../domain/repository/db_todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';
part 'todo_bloc.freezed.dart';

const String _logPref = '[BLoC - TODO]';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoApiRepository todoRepositoryApi;
  final TodoDbRepository todoRepositoryDb;
  final AppSettingsRepository appSettingsRepository;

  TodoBloc({
    required this.todoRepositoryApi,
    required this.todoRepositoryDb,
    required this.appSettingsRepository,
  }) : super(const _Initial()) {
    on<TodoEvent>(
      (event, emit) => event.map<Future<void>>(
        addTodo: (event) => _onAddTodo(event, emit),
        deleteTodo: (event) => _onDeleteTodo(event, emit),
        editTodo: (event) => _onEditTodo(event, emit),
        loadTodos: (event) => _onLoadTodo(event, emit),
        toggleIsDone: (event) => _onToggleTodo(event, emit),
        syncWithServer: (event) => _onSyncWithServer(event, emit),
      ),
    );

    add(const TodoEvent.loadTodos());
  }

  Future<void> _onAddTodo(_AddTodo event, Emitter<TodoState> emit) async {
    await todoRepositoryDb.addTodo(event.todoToAdd);
    await todoRepositoryDb.increaseRevision();

    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('Todo added: ${event.todoToAdd.id}');

    try {
      logger.i('$_logPref: Trying to sync with server...');
      await todoRepositoryApi.addTodo(event.todoToAdd);
    } on DioException catch (e) {
      logger.e('$_logPref: Failed to sync with server: $e');
      emit(TodoState.syncError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(_DeleteTodo event, Emitter<TodoState> emit) async {
    await todoRepositoryDb.deleteTodo(event.id);
    await todoRepositoryDb.increaseRevision();

    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('$_logPref: Todo deleted: ${event.id}');

    try {
      logger.i('$_logPref: Trying to sync with server...');
      await todoRepositoryApi.deleteTodo(event.id);
    } on DioException catch (e) {
      logger.e('$_logPref: Failed to sync with server: $e');
      emit(TodoState.syncError(e.toString()));
    }
  }

  Future<void> _onEditTodo(_EditTodo event, Emitter<TodoState> emit) async {
    final editedTodo = event.editedTodo;

    await todoRepositoryDb.editTodo(editedTodo.id, editedTodo);
    await todoRepositoryDb.increaseRevision();

    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('$_logPref: Todo edited: ${event.editedTodo.id}');

    try {
      logger.i('$_logPref: Trying to sync with server...');
      await todoRepositoryApi.editTodo(event.id, event.editedTodo);
    } on DioException catch (e) {
      logger.e('$_logPref: Failed to sync with server: $e');
      emit(TodoState.syncError(e.toString()));
    }
  }

  Future<void> _onLoadTodo(_LoadTodo event, Emitter<TodoState> emit) async {
    emit(const TodoState.loadingTasks());
    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('$_logPref: Tasks loaded: ${todos.length}');
  }

  Future<void> _onToggleTodo(
      _ToggleIsDone event, Emitter<TodoState> emit) async {
    final todo = await todoRepositoryDb.getTodoById(event.id);

    if (todo == null) {
      logger.e('$_logPref: Todo not found: ${event.id} !!!!!!!!');
      return;
    }

    final toggledTodo = todo.copyWith(
      isDone: !todo.isDone,
    );
    logger.e('Toggled todo: $toggledTodo');
    await todoRepositoryDb.editTodo(
      toggledTodo.id,
      toggledTodo,
    );
    await todoRepositoryDb.increaseRevision();

    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
  }

  /// Sync `Todo` tasks with server by this algorithm:
  /// ------------------------------------------------------
  /// 1. Doing stuff locally from time to time (without sync and connection)
  /// 2. When we need to sync with server, form a PATCH request with all the current changes
  ///    - Get remote/local list of `Todo` tasks + revision update
  ///    - Merge remote/local tasks by timestamps and revisions
  /// 3. Send PATCH request with local data which updates everything on the backend side
  Future<void> _onSyncWithServer(
    _SyncWithServer event,
    Emitter<TodoState> emit,
  ) async {
    final localRevision = await todoRepositoryDb.getRevision();
    final localTodos = await todoRepositoryDb.getTodos();

    final remoteTodos = await todoRepositoryApi.getTodos();
    final remoteTodoList = remoteTodos.tasks;
    final remoteRevision = remoteTodos.revision;

    for (final remoteTodo in remoteTodoList) {
      // Step 1:
      // For remote tasks which are not in local DB
      // add them if revision is greater than local revision
      if (!localTodos.any((todo) => todo.id == remoteTodo.id) &&
          localRevision < remoteRevision) {
        logger.i('$_logPref: Added remote task: ${remoteTodo.id}');
        await todoRepositoryDb.addTodo(remoteTodo);
      }

      // Step 2:
      // Otherwise if tasks in both remote and local DB
      //
      // - Update locally if remote.changedAt > local.changedAt
      // - Send to the server if remote.changedAt < local.changedAt
      else if (localTodos.any((todo) => todo.id == remoteTodo.id)) {
        logger.i(
            '$_logPref: Task in both remote and local storage: ${remoteTodo.id}');

        final localTodo = localTodos.firstWhere(
          (todo) => todo.id == remoteTodo.id,
        );

        // Local tasks is not actual (isBefore) with server
        if (localTodo.changedAt.isBefore(remoteTodo.changedAt)) {
          logger.w(
            'Local task with ${localTodo.id} updated from remote',
          );
          await todoRepositoryDb.editTodo(remoteTodo.id, remoteTodo);
        }
      }
    }

    // Step 3:
    // For local tasks which are not in remote DB
    // delete them if revision is greater than local revision
    final localOnlyTasks = localTodos.where(
      (todo) => !remoteTodoList.any((remoteTodo) => remoteTodo.id == todo.id),
    );
    for (final localTodo in localOnlyTasks) {
      if (localRevision < remoteRevision) {
        logger.w(
          '$_logPref: Delete local task ${localTodo.id} (revision higher on remote)',
        );
        await todoRepositoryDb.deleteTodo(localTodo.id);
      }
    }

    // Step 4 (After Conflicts Solving):
    // In any case we should sync local and remote revision
    if (localRevision < remoteRevision) {
      // Save revision locally if it's greater on the remote
      await todoRepositoryDb.setRevision(remoteRevision);
    } else {
      // Or, if the local win, increase the local one
      // so when we patch, revision will be set from headers
      await todoRepositoryDb.increaseRevision();
    }

    // Step 5:
    // Send PATCH request
    final todosAfterUpdate = await todoRepositoryDb.getTodos();
    try {
      await todoRepositoryApi.updateAllTodos(todosAfterUpdate);
      logger.i('$_logPref: Patch request sent');
      emit(const TodoState.syncSuccess());
    } on DioException catch (e) {
      logger.e('$_logPref: Failed to sync with server: $e');
      emit(TodoState.syncError(e.toString()));
    } finally {
      // Step 6:
      // And, of course, emit the new state:
      emit(TodoState.tasksLoaded(todosAfterUpdate));
    }
  }
}
