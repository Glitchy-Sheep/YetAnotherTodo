import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/todo/domain/entities/task_entity.dart';
import '../../feature/todo/presentation/screens/todo_create.dart';
import '../../feature/todo/presentation/screens/todo_view.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: TodoViewScreen.routeName, page: TodoViewRoute.page, initial: true),
        AutoRoute(path: TodoCreateScreen.routeName, page: TodoCreateRoute.page),
      ];
}
