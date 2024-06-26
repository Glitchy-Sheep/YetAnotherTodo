import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/uikit/app_icons.dart';
import '../../../../core/uikit/app_text_style.dart';
import '../../../../core/uikit/colors.dart';
import '../../domain/task.dart';
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
    return Dismissible(
      key: UniqueKey(),
      background: const DismissBackground(
        dismissColor: ColorPalette.lightColorGreen,
        alignment: Alignment.centerLeft,
        child: AppIcons.check,
      ),
      secondaryBackground: const DismissBackground(
        dismissColor: ColorPalette.lightColorRed,
        alignment: Alignment.centerRight,
        child: AppIcons.closeWhite,
      ),
      child: _TaskContent(
        task: widget.task,
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
        _TaskDescription(task: task),
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
      task.description,
      style: AppTextStyle.bodyText.copyWith(
        decoration: task.isDone ? TextDecoration.lineThrough : null,
        color: task.isDone ? ColorPalette.lightLabelTertiary : null,
      ),
    );
  }
}

class _TaskDescription extends StatelessWidget {
  final TaskEntity task;

  const _TaskDescription({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      task.description,
      style: AppTextStyle.bodyText.copyWith(
        decoration: task.isDone ? TextDecoration.lineThrough : null,
        color: task.isDone ? ColorPalette.lightLabelTertiary : null,
      ),
    );
  }
}
