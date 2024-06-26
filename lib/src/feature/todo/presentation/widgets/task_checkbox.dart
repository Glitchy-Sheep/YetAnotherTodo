import 'package:flutter/material.dart';
import '../../../../core/uikit/colors.dart';
import '../../domain/task.dart';

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

    if (!task.isDone && task.priority == TaskPriority.high) {
      fillColor = ColorPalette.lightColorRed.withOpacity(0.16);
      checkboxSide = const BorderSide(
        color: ColorPalette.lightColorRed,
        width: 2,
      );
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
