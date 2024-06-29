import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/api_todo_repository.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/db_todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';
part 'todo_bloc.freezed.dart';

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
        markTodoAsDone: (event) => _onMarkTodoAsDone(event, emit),
        markTodoAsUndone: (event) => _onMarkTodoAsUndone(event, emit),
        syncWithServer: (event) => _onSyncWithServer(event, emit),
      ),
    );
  }

  Future<void> _onAddTodo(_AddTodo event, Emitter<TodoState> emit) async {}
  Future<void> _onDeleteTodo(
      _DeleteTodo event, Emitter<TodoState> emit) async {}
  Future<void> _onEditTodo(_EditTodo event, Emitter<TodoState> emit) async {}
  Future<void> _onLoadTodo(_LoadTodo event, Emitter<TodoState> emit) async {
    logger.i('Trying to load todos from db...');
  }

  Future<void> _onMarkTodoAsDone(
      _MarkTodoAsDone event, Emitter<TodoState> emit) async {}
  Future<void> _onMarkTodoAsUndone(
      _MarkTodoAsUndone event, Emitter<TodoState> emit) async {}
  Future<void> _onSyncWithServer(
      _SyncWithServer event, Emitter<TodoState> emit) async {}
}
