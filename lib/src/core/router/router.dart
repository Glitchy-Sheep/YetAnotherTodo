import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/todo/presentation/screens/todo_edit_or_create_screen.dart';
import '../../feature/todo/presentation/screens/todo_view.dart';
import 'paths.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: TodoViewRoute.page,
          path: AppRouterPaths.homeTodoView,
          initial: true,
        ),
        AutoRoute(
          page: TodoEditOrCreateRoute.page,
          path: AppRouterPaths.createNewTodo,
        ),
        AutoRoute(
          page: TodoEditOrCreateRoute.page,
          path: AppRouterPaths.editTodo,
        ),
      ];
}
