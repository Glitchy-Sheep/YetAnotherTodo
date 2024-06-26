import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/date_formatters.dart';
import '../../../../uikit/app_icons.dart';
import '../../../../uikit/app_text_style.dart';
import '../../../../uikit/colors.dart';
import '../../domain/task.dart';
import '../screens/todo_create.dart';

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
          child: AppIcons.check,
        ),
      ),
      secondaryBackground: const _DismissContainer(
        dismissColor: ColorPalette.lightColorRed,
        alignment: Alignment.centerRight,
        child: AppIcons.closeWhite,
      ),
      child: _TaskContent(task: widget.task, subtitle: subtitle),
    );
  }
}

class _TaskContent extends StatelessWidget {
  final Text? subtitle;
  final TaskEntity task;

  const _TaskContent({
    required this.task,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      horizontalTitleGap: 0,
      leading: _TaskCheckBox(
        task: task,
        onCheck: (newValue) async {
          // What're you looking at? /:-)
          final url = Uri.parse('https://shorturl.at/7X7t9');
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
            style: AppTextStyle.bodyText.copyWith(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? ColorPalette.lightLabelTertiary : null,
            ),
          ),
        ],
      ),
      trailing: AppIcons.taskInfo,
      subtitle: subtitle,
    );
  }
}

class _DismissContainer extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  final Color dismissColor;

  const _DismissContainer({
    required this.dismissColor,
    required this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
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
  final TaskEntity task;
  final ValueChanged<bool?> onCheck;

  const _TaskCheckBox({
    required this.task,
    required this.onCheck,
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
