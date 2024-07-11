import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/database/database_impl.dart';
import '../../todo/bloc/todo_bloc/todo_bloc.dart';
import '../../todo/data/repository/api_todo_repository_impl.dart';
import '../../todo/data/repository/db_todo_repository_impl.dart';
import '../../todo/domain/repository/api_todo_repository.dart';
import '../../todo/domain/repository/db_todo_repository.dart';
import '../app_settings.dart';

class AppScope extends InheritedWidget {
  final TodoRepositoryApi _todoApiRepository;
  final TodoRepositoryDb todoDbRepository;
  final AppSettingsRepository _appSettingsRepository;

  late final TodoBloc todoBloc;

  AppScope({
    required super.child,
    required Dio dio,
    required AppDatabaseImpl db,
    required AppSettingsRepository appSettingsRepository,
    super.key,
  })  : _todoApiRepository = TodoRepositoryApiImpl(baseDioClient: dio),
        todoDbRepository = TodoRepositoryDbImpl(db),
        _appSettingsRepository = appSettingsRepository {
    todoBloc = TodoBloc(
      todoRepositoryApi: _todoApiRepository,
      todoRepositoryDb: todoDbRepository,
      appSettingsRepository: _appSettingsRepository,
    );
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

extension AppScopeX on BuildContext {
  AppScope get appScope => AppScope.of(this);

  AppSettingsRepository get settings => appScope._appSettingsRepository;
}
