import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yet_another_todo/src/core/database/database_impl.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/feature/todo/bloc/todo_bloc.dart';
import 'package:yet_another_todo/src/feature/todo/data/repository/api_todo_repository_impl.dart';
import 'package:yet_another_todo/src/feature/todo/data/repository/db_todo_repository_impl.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/api_todo_repository.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/db_todo_repository.dart';

class AppScope extends InheritedWidget {
  final TodoRepositoryApi _todoApiRepository;
  final TodoRepositoryDb _todoDbRepository;

  late final TodoBloc todoBloc;

  AppScope({
    required super.child,
    required Dio dio,
    required AppDatabaseImpl db,
    super.key,
  })  : _todoApiRepository = TodoRepositoryApiImpl(baseDioClient: dio),
        _todoDbRepository = TodoRepositoryDbImpl(db) {
    todoBloc = TodoBloc(
      todoRepositoryApi: _todoApiRepository,
      todoRepositoryDb: _todoDbRepository,
    )..add(const TodoEvent.loadTodos());

    logger.i('App scope initialized');
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static AppScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>()!;
  }

  static AppScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>();
  }
}
