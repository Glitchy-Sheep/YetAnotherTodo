import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/tools/app_localizations_alias.dart';
import '../../../../core/tools/logger.dart';
import '../../../../core/tools/uuid_generator.dart';
import '../../../../core/uikit/app_icons.dart';
import '../../../../core/uikit/app_text_style.dart';
import '../../../app/di/app_scope.dart';
import '../../../app/preferences.dart';
import '../../bloc/todo_bloc/todo_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../widgets/dynamic_appbar.dart';
import '../widgets/task_tile.dart';
import 'todo_create.dart';

/// Main screen which shows the list of todos
class TodoViewScreen extends StatelessWidget {
  const TodoViewScreen({super.key});

  // TODO: Something is slightly wrong with "update tasks" process,
  // for some reason the screen blinks sometimes
  //
  // it happends on update tasks, I think it's because of rebuild during emits
  // or something like that. I'm not sure how to fix it now.
  //
  // Maybe I need to pass key somewhere, but for now I'm not sure.
  // If you know how to do it properly, please let me know.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: () async {
            AppScope.of(context).todoBloc.add(
                  const TodoEvent.syncWithServer(),
                );
          },
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DynamicSliverAppBar(
                  expandedHeight: 148,
                  collapsedHeight: 88,
                  completedTasksVisibility: ValueNotifier(
                    context.preferences.isCompletedTasksVissible,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: BlocBuilder<TodoBloc, TodoState>(
                  bloc: AppScope.of(context).todoBloc,
                  builder: (context, state) {
                    final isDoneTasksVisible =
                        context.preferences.isCompletedTasksVissible;

                    return state.map(
                      initial: (state) => const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      loadingTasks: (state) => const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
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
                        child: Text('Error occurred'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _AddTaskFloatingActionButton(
          onPressed: () => onAddTaskPressed(context),
        ),
      ),
    );
  }

  void onAddTaskPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<TodoCreateScreen>(
        builder: (context) => const TodoCreateScreen(),
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
                  // MarkTodoAsDone
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

    AppScope.of(context).todoBloc
      ..add(
        TodoEvent.addTodo(
          TaskEntity(
            id: UuidGenerator.v4(),
            description: value,
            isDone: false,
            createdAt: DateTime.now(),
            changedAt: DateTime.now(),
          ),
        ),
      )
      ..add(const TodoEvent.loadTodos());

    textController.clear();
  }
}
