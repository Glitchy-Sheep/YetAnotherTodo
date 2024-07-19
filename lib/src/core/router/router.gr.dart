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
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TodoEditOrCreateRouteArgs>(
          orElse: () => TodoEditOrCreateRouteArgs(
              taskToEdit: pathParams.optString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoEditOrCreateScreen(
          taskToEdit: args.taskToEdit,
          key: args.key,
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
    String? taskToEdit,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          TodoEditOrCreateRoute.name,
          args: TodoEditOrCreateRouteArgs(
            taskToEdit: taskToEdit,
            key: key,
          ),
          rawPathParams: {'id': taskToEdit},
          initialChildren: children,
        );

  static const String name = 'TodoEditOrCreateRoute';

  static const PageInfo<TodoEditOrCreateRouteArgs> page =
      PageInfo<TodoEditOrCreateRouteArgs>(name);
}

class TodoEditOrCreateRouteArgs {
  const TodoEditOrCreateRouteArgs({
    this.taskToEdit,
    this.key,
  });

  final String? taskToEdit;

  final Key? key;

  @override
  String toString() {
    return 'TodoEditOrCreateRouteArgs{taskToEdit: $taskToEdit, key: $key}';
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
