import 'package:flutter/material.dart';
import '../../../../core/uikit/uikit.dart';
import '../../domain/entities/task_entity.dart';

class TaskCheckBox extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onCheck;

  const TaskCheckBox({
    required this.task,
    required this.onCheck,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor = getCheckboxFillColor(task, context);
    final checkboxSide = getCheckboxSide(task, context);

    return Checkbox(
      value: task.isDone,
      onChanged: onCheck,
      activeColor: ColorPalette.lightColorGreen,
      checkColor: ColorPalette.lightColorWhite,
      fillColor: WidgetStateProperty.resolveWith(
        (state) => fillColor,
      ),
      side: checkboxSide,
    );
  }

  Color? getCheckboxFillColor(TaskEntity task, BuildContext context) {
    if (!task.isDone && task.priority == TaskPriority.important) {
      return Theme.of(context).colorScheme.error.withOpacity(0.16);
    } else {
      return null;
    }
  }

  BorderSide? getCheckboxSide(TaskEntity task, BuildContext context) {
    if (!task.isDone && task.priority == TaskPriority.important) {
      return BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 2,
      );
    } else {
      return BorderSide(
        color: Theme.of(context).dividerColor,
        width: 2,
      );
    }
  }
}
