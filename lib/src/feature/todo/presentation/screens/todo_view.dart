import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../core/tools/tools.dart';
import '../../../../core/uikit/theme_shortcut.dart';
import '../../../../core/uikit/uikit.dart';
import '../../../app/bloc/internet_cubit/internet_cubit.dart';
import '../../../app/di/app_scope.dart';
import '../../bloc/todo_bloc/todo_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../widgets/dynamic_appbar.dart';
import '../widgets/task_tile.dart';

/// Main screen which shows the list of todos

@RoutePage()
class TodoViewScreen extends StatelessWidget {
  const TodoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<InternetCubit, InternetState>(
          bloc: AppScope.of(context).internetCubit,
          listener: _startUpChore,
          child: RefreshIndicator(
            onRefresh: () async => _onRefreshTasks(context),
            child: const CustomScrollView(
              slivers: [
                _SliverTodoViewAppBar(),
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: _SliverTodoListView(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _AddTaskFloatingActionButton(
        onPressed: () => onAddTaskPressed(context),
      ),
    );
  }

  void onAddTaskPressed(BuildContext context) {
    logger.i('Pushed create route');
    context.router.push(TodoEditOrCreateRoute());
  }

  // Before refresh we can check the internet state
  // and notify user about lost connection
  Future<void> _onRefreshTasks(BuildContext context) async {
    final internetState = context.appScope.internetCubit.state;
    if (internetState != InternetState.connected) {
      _notifyAboutInternetStatus(context, internetState);
      return;
    }
    context.appScope.todoBloc.add(const TodoEvent.syncWithServer());
  }

  // This method is called when the internet state changes
  //
  // It will:
  // 1. Notify user about lost internet connection
  // 2. Sync with server if connection is restored
  void _startUpChore(
    BuildContext context,
    InternetState state,
  ) {
    switch (state) {
      case InternetState.initial:
        return;
      case InternetState.connected:
        AppScope.of(context).todoBloc.add(const TodoEvent.syncWithServer());
      case InternetState.disconnected:
        _notifyAboutInternetStatus(context, state);
    }
  }

  void _notifyAboutInternetStatus(BuildContext context, InternetState state) {
    if (state == InternetState.disconnected) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No internet connection. Data will be synchronized when the connection is restored. In the meantime, you can continue adding tasks locally.',
          ),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}

class _SliverTodoListView extends StatelessWidget {
  const _SliverTodoListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: AppScope.of(context).todoBloc,
      buildWhen: (previous, current) => !current.isNotification,
      listenWhen: (previous, current) => current.isNotification,
      listener: (context, state) {
        if (state.isSyncSuccessNotification) {
          _notifyAboutSyncSuccess(context);
        } else if (state.isSyncErrorNotification) {
          _notifyAboutSyncError(context);
        }
      },
      builder: (context, state) {
        final isDoneTasksVisible = context.settings.isCompletedTasksVissible;

        return state.maybeMap(
          initial: (state) => const _LoadingTasksIndicator(),
          loadingTasks: (state) => const _LoadingTasksIndicator(),
          tasksLoaded: (state) {
            final tasks = isDoneTasksVisible
                ? state.tasks
                : state.tasks.where((task) => !task.isDone).toList();

            return DecoratedSliver(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              sliver: _TaskList(tasks: tasks),
            );
          },
          // Should never happen because of the buildWhen filters
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  void _notifyAboutSyncError(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // content: Text("Can't sync with server, task will be changed locally."),
        content: Text(context.strings.cantSyncWithServer),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _notifyAboutSyncSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.strings.syncSuccess),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

class _LoadingTasksIndicator extends StatelessWidget {
  const _LoadingTasksIndicator();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _SliverTodoViewAppBar extends StatelessWidget {
  const _SliverTodoViewAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: DynamicSliverAppBar(
        expandedHeight: 148,
        collapsedHeight: 88,
        completedTasksVisibility: ValueNotifier(
          context.settings.isCompletedTasksVissible,
        ),
      ),
    );
  }
}

class _AddTaskFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _AddTaskFloatingActionButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor:
              context.theme.floatingActionButtonTheme.backgroundColor,
          child: AppIcons.add,
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
  });

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return TaskTile(
                key: ValueKey(tasks[index].id),
                task: tasks[index],
                onCheck: (newValue) {
                  context.appScope.todoBloc.add(
                    TodoEvent.toggleIsDone(
                      tasks[index].id,
                    ),
                  );
                },
              );
            },
            childCount: tasks.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: _FastTaskCreationField(),
        )
      ],
    );
  }
}

class _FastTaskCreationField extends StatefulWidget {
  const _FastTaskCreationField();

  @override
  State<_FastTaskCreationField> createState() => _FastTaskCreationFieldState();
}

class _FastTaskCreationFieldState extends State<_FastTaskCreationField> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 52,
        top: 12,
        bottom: 12,
        right: 12,
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration.collapsed(
          hintText: context.strings.newTodo,
          hintStyle: AppTextStyle.subheadText,
        ),
        style: AppTextStyle.bodyText,
        onSubmitted: (newValue) => onSubmitted(context, newValue),
      ),
    );
  }

  void onSubmitted(BuildContext context, String value) {
    if (value.isEmpty) {
      logger.i('Fast task creation cancelled (empty value)');
      return;
    }

    logger.i('Fast task creation submitted');

    final timestamp = DateTime.now();

    AppScope.of(context).todoBloc.add(
          TodoEvent.addTodo(
            TaskEntity(
              id: UuidGenerator.v4(),
              description: value,
              isDone: false,
              createdAt: timestamp,
              changedAt: timestamp,
            ),
          ),
        );

    textController.clear();
  }
}
