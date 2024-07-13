import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/router.dart';
import '../../../../core/tools/tools.dart';
import '../../../../core/uikit/uikit.dart';
import '../../../app/di/app_scope.dart';
import '../../bloc/todo_bloc/todo_bloc.dart';
import '../../domain/entities/task_entity.dart';
import 'dismiss_background.dart';
import 'task_checkbox.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onCheck;

  const TaskTile({
    required this.task,
    required this.onCheck,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        key: ValueKey(task.id),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            context.appScope.todoBloc.add(
              TodoEvent.deleteTodo(task.id),
            );
          } else if (direction == DismissDirection.startToEnd) {
            context.appScope.todoBloc.add(
              TodoEvent.deleteTodo(task.id),
            );
          }
        },
        background: DismissBackground(
          dismissColor: Theme.of(context).colorScheme.secondary,
          alignment: Alignment.centerLeft,
          child: AppIcons.check,
        ),
        secondaryBackground: DismissBackground(
          dismissColor: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          child: AppIcons.closeWhite,
        ),
        child: _TaskListTileContent(
          task: task,
        ),
      ),
    );
  }
}

class _TaskListTileContent extends StatelessWidget {
  final TaskEntity task;

  const _TaskListTileContent({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        horizontalTitleGap: 0,
        leading: TaskCheckBox(
          task: task,
          onCheck: (newValue) async {
            context.appScope.todoBloc.add(
              TodoEvent.toggleIsDone(
                task.id,
              ),
            );
          },
        ),
        title: _TaskTitle(task: task),
        trailing: GestureDetector(
          onTap: () => onTaskEditClicked(context),
          child: AppIcons.taskInfo,
        ),
        subtitle: generateTaskTileSubtitle(task));
  }

  Future<void> onTaskEditClicked(BuildContext context) async {
    await context.router.push(
      TodoEditOrCreateRoute(taskToEdit: task.id),
    );
  }

  _TaskDeadlineSubtitle? generateTaskTileSubtitle(TaskEntity task) {
    if (task.finishUntil == null) {
      return null;
    } else {
      return _TaskDeadlineSubtitle(
        task: task,
      );
    }
  }
}

class _TaskTitle extends StatelessWidget {
  final TaskEntity task;

  const _TaskTitle({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          if (task.priority == TaskPriority.important)
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: AppIcons.exclamationMarks,
              ),
            ),
          if (task.priority == TaskPriority.low)
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: AppIcons.arrowDownImportance,
              ),
            ),
          TextSpan(
            text: task.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? theme.colorScheme.tertiary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskDeadlineSubtitle extends StatelessWidget {
  final TaskEntity task;

  const _TaskDeadlineSubtitle({required this.task});

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormatters.toDayMonthYear(
          task.finishUntil!, context.strings.localeName),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
    );
  }
}
