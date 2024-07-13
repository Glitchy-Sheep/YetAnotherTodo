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
    TodoCreateRoute.name: (routeData) {
      final args = routeData.argsAs<TodoCreateRouteArgs>(
          orElse: () => const TodoCreateRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoEditAndCreateScreen(
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
/// [TodoEditAndCreateScreen]
class TodoCreateRoute extends PageRouteInfo<TodoCreateRouteArgs> {
  TodoCreateRoute({
    Key? key,
    String? taskToEdit,
    List<PageRouteInfo>? children,
  }) : super(
          TodoCreateRoute.name,
          args: TodoCreateRouteArgs(
            key: key,
            taskToEdit: taskToEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'TodoCreateRoute';

  static const PageInfo<TodoCreateRouteArgs> page =
      PageInfo<TodoCreateRouteArgs>(name);
}

class TodoCreateRouteArgs {
  const TodoCreateRouteArgs({
    this.key,
    this.taskToEdit,
  });

  final Key? key;

  final String? taskToEdit;

  @override
  String toString() {
    return 'TodoCreateRouteArgs{key: $key, taskToEdit: $taskToEdit}';
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
