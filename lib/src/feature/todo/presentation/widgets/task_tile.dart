import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/tools/app_localizations_alias.dart';
import '../../../../core/tools/date_formatters.dart';
import '../../../../core/uikit/app_icons.dart';
import '../../domain/entities/task_entity.dart';
import 'dismiss_background.dart';
import 'task_checkbox.dart';

class TaskTile extends StatefulWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onCheck;

  const TaskTile({
    required this.task,
    required this.onCheck,
    super.key,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        key: UniqueKey(),
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
        child: _TaskContent(
          task: widget.task,
        ),
      ),
    );
  }
}

class _TaskContent extends StatelessWidget {
  final TaskEntity task;

  const _TaskContent({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: TaskCheckBox(
        task: task,
        onCheck: (newValue) async {},
      ),
      title: _TaskTitle(task: task),
      trailing: AppIcons.taskInfo,
      subtitle: task.finishUntil == null
          ? null
          : _TaskDeadlineSubtitle(
              task: task,
            ),
    );
  }
}

class _TaskTitle extends StatelessWidget {
  final TaskEntity task;

  const _TaskTitle({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (task.priority == TaskPriority.high)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SvgPicture.asset(
              'assets/icons/exclamation_marks.svg',
            ),
          ),
        if (task.priority == TaskPriority.low)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SvgPicture.asset(
              'assets/icons/arrow_down.svg',
            ),
          ),
        Text(
          task.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color:
                    task.isDone ? Theme.of(context).colorScheme.tertiary : null,
              ),
        ),
      ],
    );
  }
}

class _TaskDeadlineSubtitle extends StatelessWidget {
  final TaskEntity task;

  const _TaskDeadlineSubtitle({required this.task});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDate(task.finishUntil!, context.strings.localeName),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
    );
  }
}
