import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/tools/tools.dart';
import '../../../app/app_settings.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/api_todo_repository.dart';
import '../../domain/repository/db_todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';
part 'todo_bloc.freezed.dart';

const String _loggerPrefix = '[BLoC - TODO]';

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
    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('Todo added: ${event.todoToAdd.id}');
  }

  Future<void> _onDeleteTodo(_DeleteTodo event, Emitter<TodoState> emit) async {
    await todoRepositoryDb.deleteTodo(event.id);
    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('$_loggerPrefix: Todo deleted: ${event.id}');
  }

  Future<void> _onEditTodo(_EditTodo event, Emitter<TodoState> emit) async {
    await todoRepositoryDb.editTodo(event.editedTodo.id, event.editedTodo);
    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('$_loggerPrefix: Todo edited: ${event.editedTodo.id}');
  }

  Future<void> _onLoadTodo(_LoadTodo event, Emitter<TodoState> emit) async {
    emit(const TodoState.loadingTasks());
    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i('$_loggerPrefix: Tasks loaded: ${todos.length}');
  }

  Future<void> _onToggleTodo(
      _ToggleIsDone event, Emitter<TodoState> emit) async {
    final todo = await todoRepositoryDb.getTodoById(event.id);
    if (todo == null) {
      return;
    }

    final toggledTodo = todo.copyWith(isDone: !todo.isDone);
    await todoRepositoryDb.editTodo(toggledTodo.id, toggledTodo);

    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
    logger.i(
        '$_loggerPrefix: Todo toggled: ${toggledTodo.id} = ${toggledTodo.isDone}');
  }

  /// Sync `Todo` tasks with server by this algorithm:
  /// ------------------------------------------------------
  /// 1. Get updated list of `Todo` tasks + revision update
  /// 2. Merge new Todos with existing ones in DB
  /// 3. Doing stuff locally from time to time (without sync and connection)
  /// 4. When we need to sync with server, form a PATCH request with all the current changes
  /// 5. Send PATCH request and wait for server response in which we have updated data
  Future<void> _onSyncWithServer(
      _SyncWithServer event, Emitter<TodoState> emit) async {
    await todoRepositoryDb.deleteAllTodos();
    // Before sync we must to make sure that app can work locally
  }
}
