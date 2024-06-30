import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/api_todo_repository.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/db_todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';
part 'todo_bloc.freezed.dart';

const String _loggerPrefix = '[BLoC - TODO]';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepositoryApi todoRepositoryApi;
  final TodoRepositoryDb todoRepositoryDb;

  TodoBloc({
    required this.todoRepositoryApi,
    required this.todoRepositoryDb,
  }) : super(const _Initial()) {
    on<TodoEvent>(
      (event, emit) => event.map<Future<void>>(
        addTodo: (event) => _onAddTodo(event, emit),
        deleteTodo: (event) => _onDeleteTodo(event, emit),
        editTodo: (event) => _onEditTodo(event, emit),
        loadTodos: (event) => _onLoadTodo(event, emit),
        toggleIsDone: (event) => _onMarkTodoAsDone(event, emit),
        syncWithServer: (event) => _onSyncWithServer(event, emit),
      ),
    );
  }

  Future<void> _onAddTodo(_AddTodo event, Emitter<TodoState> emit) async {
    await todoRepositoryDb.addTodo(event.todoToAdd);
  }

  Future<void> _onDeleteTodo(
      _DeleteTodo event, Emitter<TodoState> emit) async {}

  Future<void> _onEditTodo(_EditTodo event, Emitter<TodoState> emit) async {}

  Future<void> _onLoadTodo(_LoadTodo event, Emitter<TodoState> emit) async {
    logger.i('$_loggerPrefix: Loading todos from db...');

    emit(const TodoState.loadingTasks());
    final todos = await todoRepositoryDb.getTodos();
    emit(TodoState.tasksLoaded(todos));
  }

  Future<void> _onMarkTodoAsDone(
      _ToggleIsDone event, Emitter<TodoState> emit) async {
    final todo = await todoRepositoryDb.getTodoById(event.id);
    if (todo == null) {
      return;
    }

    final toggledTodo = todo.copyWith(isDone: !todo.isDone);

    await todoRepositoryDb.editTodo(toggledTodo.id, toggledTodo);

    // Damn that's bad
    final todos = await todoRepositoryDb.getTodos();

    emit(TodoState.tasksLoaded(todos));
  }

  Future<void> _onSyncWithServer(
      _SyncWithServer event, Emitter<TodoState> emit) async {}
}
