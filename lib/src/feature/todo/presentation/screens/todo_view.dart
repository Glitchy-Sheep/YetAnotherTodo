import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../core/tools/tools.dart';
import '../../../../core/uikit/uikit.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            AppScope.of(context).todoBloc.add(
                  const TodoEvent.syncWithServer(),
                );
          },
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
      floatingActionButton: _AddTaskFloatingActionButton(
        onPressed: () => onAddTaskPressed(context),
      ),
    );
  }

  void onAddTaskPressed(BuildContext context) {
    logger.i('Pushed create route');
    context.router.push(TodoCreateRoute());
  }
}

class _SliverTodoListView extends StatelessWidget {
  const _SliverTodoListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      bloc: AppScope.of(context).todoBloc,
      builder: (context, state) {
        final isDoneTasksVisible = context.settings.isCompletedTasksVissible;

        return state.map(
          initial: (state) => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          loadingTasks: (state) => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          tasksLoaded: (state) => DecoratedSliver(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            sliver: _TaskList(
              tasks: isDoneTasksVisible
                  ? state.tasks
                  : state.tasks
                      .where(
                        (task) => !task.isDone,
                      )
                      .toList(),
            ),
          ),
          error: (state) => const SliverToBoxAdapter(
            // TODO: Handle the error accordingly
            child: Text('Error occurred'),
          ),
        );
      },
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
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
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

    AppScope.of(context).todoBloc.add(
          TodoEvent.addTodo(
            TaskEntity(
              id: UuidGenerator.v4(),
              description: value,
              isDone: false,
              createdAt: DateTime.now(),
              changedAt: DateTime.now(),
            ),
          ),
        );

    textController.clear();
  }
}
