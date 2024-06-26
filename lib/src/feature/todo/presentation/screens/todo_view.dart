import 'package:flutter/material.dart';

import '../../../../core/uikit/app_icons.dart';
import '../../domain/task.dart';
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
                completedTasksVisibility: ValueNotifier(true),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: _TaskList(),
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
  const _TaskList();

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            // Some stub data to show all the cases
            final TaskPriority priority;
            if (index % 3 == 0) {
              priority = TaskPriority.high;
            } else if (index % 4 == 0) {
              priority = TaskPriority.low;
            } else {
              priority = TaskPriority.none;
            }

            return TaskTile(
              task: TaskEntity(
                id: 1,
                description: 'Нажать на галочку',
                isDone: index % 2 == 0 ? true : false,
                finishUntil: index % 3 == 0 ? DateTime.now() : null,
                priority: priority,
              ),
              onCheck: (newValue) {},
            );
          },
        ),
      ),
    );
  }
}
