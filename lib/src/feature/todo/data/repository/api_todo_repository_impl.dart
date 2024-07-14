import 'package:dio/dio.dart';

import '../../../../core/api/interceptors/last_known_revision_interceptor.dart';
import '../../../../core/tools/logger.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/api_todo_repository.dart';
import '../mappers/task_mapper.dart';
import '../models/get_todo_by_id_response.dart';
import '../models/get_todo_list_response.dart';

class TodoApiRepositoryImpl implements TodoApiRepository {
  final Dio _dioClient;

  /// This is a provider of local stored revision.
  /// it can be stored anywhere, in our case in the db.
  final RevisionGetter lastKnownRevisionGetter;

  TodoApiRepositoryImpl({
    required Dio baseDioClient,
    required this.lastKnownRevisionGetter,
  }) : _dioClient = baseDioClient {
    _dioClient.interceptors.add(
      LastKnownRevisionInterceptor(
        lastRevisionGetter: lastKnownRevisionGetter,
      ),
    );
  }

  static const _todoHandle = '/list';

  @override
  Future<void> addTodo(TaskEntity todo) async {
    await _dioClient.post(
      _todoHandle,
      data: {
        'element': TaskMapper.fromEntityToModel(todo).toJson(),
      },
    );
  }

  @override
  Future<TaskEntity?> deleteTodo(String id) async {
    try {
      final response = await _dioClient.delete(
        '$_todoHandle/$id',
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
      '$_todoHandle/$id',
      data: {
        'element': TaskMapper.fromEntityToModel(todo).toJson(),
      },
    );
  }

  @override
  Future<TaskEntity?> getTodoById(String id) async {
    final response = await _dioClient.get(
      '$_todoHandle/$id',
    );

    final responseModel = GetTodoByIdResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return TaskMapper.fromModelToEntity(responseModel.element);
  }

  @override
  Future<List<TaskEntity>> getTodos() async {
    final response = await _dioClient.get('/list');
    final allTodos = GetTodoListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return allTodos.list
        .map(
          TaskMapper.fromModelToEntity,
        )
        .toList();
  }

  @override
  Future<List<TaskEntity>> updateAllTodos(List<TaskEntity> todos) async {
    final tasksModels = todos
        .map(
          TaskMapper.fromEntityToModel,
        )
        .toList();

    final response = await _dioClient.patch(_todoHandle, data: {
      'list': tasksModels,
    });

    final allTodos = GetTodoListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return allTodos.list
        .map(
          TaskMapper.fromModelToEntity,
        )
        .toList();
  }
}
