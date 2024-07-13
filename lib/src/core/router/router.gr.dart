// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    TodoEditOrCreateRoute.name: (routeData) {
      final args = routeData.argsAs<TodoEditOrCreateRouteArgs>(
          orElse: () => const TodoEditOrCreateRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoEditOrCreateScreen(
          key: args.key,
          taskToEdit: args.taskToEdit,
        ),
      );
    },
    TodoViewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoViewScreen(),
      );
    },
  };
}

/// generated route for
/// [TodoEditOrCreateScreen]
class TodoEditOrCreateRoute extends PageRouteInfo<TodoEditOrCreateRouteArgs> {
  TodoEditOrCreateRoute({
    Key? key,
    String? taskToEdit,
    List<PageRouteInfo>? children,
  }) : super(
          TodoEditOrCreateRoute.name,
          args: TodoEditOrCreateRouteArgs(
            key: key,
            taskToEdit: taskToEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'TodoEditOrCreateRoute';

  static const PageInfo<TodoEditOrCreateRouteArgs> page =
      PageInfo<TodoEditOrCreateRouteArgs>(name);
}

class TodoEditOrCreateRouteArgs {
  const TodoEditOrCreateRouteArgs({
    this.key,
    this.taskToEdit,
  });

  final Key? key;

  final String? taskToEdit;

  @override
  String toString() {
    return 'TodoEditOrCreateRouteArgs{key: $key, taskToEdit: $taskToEdit}';
  }
}

/// generated route for
/// [TodoViewScreen]
class TodoViewRoute extends PageRouteInfo<void> {
  const TodoViewRoute({List<PageRouteInfo>? children})
      : super(
          TodoViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoViewRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
