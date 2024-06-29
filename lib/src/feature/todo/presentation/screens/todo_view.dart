import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:yet_another_todo/src/core/tools/app_localizations_alias.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/core/uikit/app_text_style.dart';
import 'package:yet_another_todo/src/feature/app/di/app_scope.dart';
import 'package:yet_another_todo/src/feature/app/preferences.dart';
import 'package:yet_another_todo/src/feature/todo/bloc/todo_bloc.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

import '../../../../core/uikit/app_icons.dart';
import '../widgets/dynamic_appbar.dart';
import '../widgets/task_tile.dart';
import 'todo_create.dart';

/// Main screen which shows the list of todos
class TodoViewScreen extends StatelessWidget {
  const TodoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
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
                      sliver: _TaskList(tasks: state.tasks),
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
  const _FastTaskCreationField({super.key});

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
            id: AppScope.of(context).uuidGenerator.v4(),
            description: value,
            isDone: false,
          ),
        ),
      )
      ..add(const TodoEvent.loadTodos());

    textController.clear();
  }
}
