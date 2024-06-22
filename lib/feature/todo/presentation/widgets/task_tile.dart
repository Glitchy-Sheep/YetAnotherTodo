import 'package:flutter/material.dart';
import 'package:yet_another_todo/feature/todo/domain/task.dart';
import 'package:yet_another_todo/uikit/app_text_style.dart';
import 'package:yet_another_todo/uikit/colors.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onCheck,
  });

  final TaskEntity task;
  final Function(bool?) onCheck;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final subtitle = widget.task.finishUntil != null
        ? Text(
            widget.task.finishUntil.toString(),
            style: const TextStyle(
              color: ColorPalette.lightLabelTertiary,
            ),
          )
        : null;

    return Dismissible(
      key: UniqueKey(),
      background: const _DismissContainer(
        dismissColor: ColorPalette.lightColorGreen,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.check,
          color: ColorPalette.lightColorWhite,
        ),
      ),
      secondaryBackground: const _DismissContainer(
        dismissColor: ColorPalette.lightColorRed,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.close,
          color: ColorPalette.lightColorWhite,
        ),
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: _TaskCheckBox(
          task: widget.task,
          onCheck: (newValue) {},
        ),
        title: Text(
          widget.task.description,
          style: AppTextStyle.bodyText.copyWith(),
        ),
        trailing: const Icon(
          Icons.info_outline,
          color: ColorPalette.lightLabelTertiary,
        ),
        subtitle: subtitle,
      ),
    );
  }
}

class _DismissContainer extends StatelessWidget {
  const _DismissContainer({
    required this.dismissColor,
    required this.alignment,
    required this.child,
  });

  final Color dismissColor;
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dismissColor,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}

class _TaskCheckBox extends StatelessWidget {
  const _TaskCheckBox({
    required this.task,
    required this.onCheck,
  });

  final TaskEntity task;
  final Function(bool?) onCheck;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: task.isDone,
      onChanged: onCheck,
      activeColor: ColorPalette.lightColorGreen,
      checkColor: ColorPalette.lightColorWhite,
    );
  }
}
