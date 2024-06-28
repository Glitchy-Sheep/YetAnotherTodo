import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yet_another_todo/core/utils/date_formatters.dart';
import 'package:yet_another_todo/core/utils/logger.dart';
import 'package:yet_another_todo/feature/todo/domain/task.dart';
import 'package:yet_another_todo/feature/todo/domain/task_priority.dart';
import 'package:yet_another_todo/feature/todo/presentation/screens/todo_create.dart';
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
            formatDate(widget.task.finishUntil!),
            style: const TextStyle(
              color: ColorPalette.lightLabelTertiary,
            ),
          )
        : null;

    return Dismissible(
      key: UniqueKey(),
      background: _DismissContainer(
        dismissColor: ColorPalette.lightColorGreen,
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoCreateScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.check,
            color: ColorPalette.lightColorWhite,
          ),
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
      child: _TaskContent(task: widget.task, subtitle: subtitle),
    );
  }
}

class _TaskContent extends StatelessWidget {
  const _TaskContent({
    super.key,
    required this.task,
    required this.subtitle,
  });

  final Text? subtitle;
  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      horizontalTitleGap: 0,
      leading: _TaskCheckBox(
        task: task,
        onCheck: (newValue) async {
          // What're you looking at? /:-)
          final Uri url = Uri.parse('https://shorturl.at/7X7t9');
          await launchUrl(url);
        },
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (task.priority == TaskPriority.high)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: SvgPicture.asset(
                "assets/icons/exclamation_marks.svg",
              ),
            ),
          if (task.priority == TaskPriority.low)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: SvgPicture.asset(
                "assets/icons/arrow_down.svg",
              ),
            ),
          Text(
            task.description,
            style: AppTextStyle.bodyText.copyWith(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? ColorPalette.lightLabelTertiary : null,
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.info_outline,
        color: ColorPalette.lightLabelTertiary,
      ),
      subtitle: subtitle,
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
