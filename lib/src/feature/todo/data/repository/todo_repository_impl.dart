import 'package:dio/dio.dart';
import 'package:yet_another_todo/src/core/api/last_known_revision_interceptor.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/feature/todo/data/mappers/task_mapper.dart';
import 'package:yet_another_todo/src/feature/todo/data/models/get_todo_by_id_response.dart';
import 'package:yet_another_todo/src/feature/todo/data/models/get_todo_list_response.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final Dio _dioClient;
  final Dio _revisionDioClient;

  TodoRepositoryImpl({
    required Dio baseDioClient,
    // Make a copy of baseDioClient
  })  : _dioClient = baseDioClient,
        _revisionDioClient = Dio(baseDioClient.options) {
    // For getting revision
    _revisionDioClient.interceptors.addAll(baseDioClient.interceptors);

    // For all other requests
    _dioClient.interceptors.add(
      LastKnownRevisionInterceptor(_getLastRevision),
    );
  }

  /// FOR NETWORK TESTS ONLY
  /// will be replaced with a proper implementation
  /// revision will be stored in some kind of persistent storage
  Future<int> _getLastRevision() async {
    final response = await _revisionDioClient.get('/list');
    final tasksInfo = GetTodoListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    final lastKnownRevision = tasksInfo.revision;

    logger.i('Last known revision: $lastKnownRevision');

    return lastKnownRevision;
  }

  @override
  Future<void> addTodo(TaskEntity todo) async {
    await _dioClient.post(
      '/list',
      data: {
        'element': TaskMapper.toModel(todo).toJson(),
      },
    );
  }

  @override
  Future<TaskEntity?> deleteTodo(String id) async {
    try {
      final response = await _dioClient.delete(
        '/list/$id',
      );
      logger.i('DELETE RESPONSE: ${response.data}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
    return null;
  }

  @override
  Future<void> editTodo(String id, TaskEntity todo) async {
    await _dioClient.put(
      '/list/$id',
      data: {
        'element': TaskMapper.toModel(todo).toJson(),
      },
    );
  }

  @override
  Future<TaskEntity?> getTodoById(int id) async {
    final response = await _dioClient.get(
      '/list/$id',
    );

    final responseModel = GetTodoByIdResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return TaskMapper.toEntity(responseModel.element);
  }

  @override
  Future<List<TaskEntity>> getTodos() async {
    final response = await _dioClient.get('/list');
    final allTodos = GetTodoListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return allTodos.list
        .map(
          TaskMapper.toEntity,
        )
        .toList();
  }
}
