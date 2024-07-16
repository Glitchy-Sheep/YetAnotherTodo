import 'package:flutter/material.dart';
import '../../../../core/uikit/colors.dart';
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
    Color? fillColor;
    BorderSide? checkboxSide;

    if (!task.isDone) {
      if (task.priority == TaskPriority.important) {
        fillColor = Theme.of(context).colorScheme.error.withOpacity(0.16);
        checkboxSide = BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        );
      } else {
        checkboxSide = BorderSide(
          color: Theme.of(context).dividerColor,
          width: 2,
        );
      }
    }

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
}
