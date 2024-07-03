import 'package:flutter/material.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/core/tools/uuid_generator.dart';
import 'package:yet_another_todo/src/feature/app/di/app_scope.dart';
import 'package:yet_another_todo/src/feature/todo/bloc/todo_bloc.dart';

import '../../../../core/tools/app_localizations_alias.dart';
import '../../../../core/tools/date_formatters.dart';
import '../../../../core/uikit/app_icons.dart';
import '../../../../core/uikit/app_text_style.dart';
import '../../../../core/uikit/colors.dart';
import '../../../../core/uikit/decorations.dart';
import '../../domain/entities/task_entity.dart';

class TodoCreateScreen extends StatefulWidget {
  const TodoCreateScreen({
    super.key,
    this.taskToEdit,
  });

  final TaskEntity? taskToEdit;

  @override
  State<TodoCreateScreen> createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TodoCreateScreen> {
  late final bool isNewTask;

  late TaskEntity _editingTask;

  @override
  void initState() {
    super.initState();

    isNewTask = widget.taskToEdit == null;

    if (widget.taskToEdit == null) {
      _editingTask = TaskEntity(
        id: UuidGenerator.v4(),
        description: '',
        isDone: false,
        createdAt: DateTime.now(),
        changedAt: DateTime.now(),
      );
    } else {
      _editingTask = widget.taskToEdit!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _AddTaskAppBar(
        onSubmit: onSubmit,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TodoCreationForm(
                  onDeadlineChanged: onDeadlineChanged,
                  onDescriptionChanged: onDescriptionChanged,
                  onPriorityChanged: onPriorityChanged,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              _DeleteButton(
                isActive: !isNewTask,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDescriptionChanged(String description) {
    _editingTask = _editingTask.copyWith(description: description);
    logger.i('New description: ${_editingTask.description}');
  }

  void onPriorityChanged(TaskPriority priority) {
    _editingTask = _editingTask.copyWith(priority: priority);
    logger.i('New priority: ${_editingTask.priority}');
  }

  void onDeadlineChanged(DateTime? date) {
    _editingTask = _editingTask.copyWith(finishUntil: date);
    logger.i('New deadline: ${_editingTask.finishUntil}');
  }

  void onSubmit() {
    if (_editingTask.description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.enterDescription),
          duration: const Duration(milliseconds: 600),
        ),
      );
      return;
    }

    logger.i('adding todo: $_editingTask');

    AppScope.of(context).todoBloc
      ..add(
        TodoEvent.addTodo(
          _editingTask,
        ),
      )
      ..add(
        const TodoEvent.loadTodos(),
      );
    Navigator.of(context).pop();
  }
}

class TodoCreationForm extends StatelessWidget {
  final ValueChanged<TaskPriority> onPriorityChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<DateTime?> onDeadlineChanged;

  const TodoCreationForm({
    required this.onPriorityChanged,
    required this.onDescriptionChanged,
    required this.onDeadlineChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DescriptionInputArea(
          onDescriptionChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 28),
        Text(
          context.strings.importance,
          style: AppTextStyle.bodyText,
        ),
        _PriorityDropdownButton(
          onPriorityChanged: onPriorityChanged,
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        _DeadlineDatePicker(
          onDeadlineChanged: onDeadlineChanged,
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final bool isActive;

  const _DeleteButton({
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.tertiary;

    return TextButton(
      onPressed: isActive ? () {} : null,
      child: Row(
        children: [
          // Workaround for color change
          Icon(Icons.delete, color: color),
          const SizedBox(width: 12),
          Text(
            context.strings.delete,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeadlineDatePicker extends StatefulWidget {
  final ValueChanged<DateTime?> onDeadlineChanged;

  const _DeadlineDatePicker({
    required this.onDeadlineChanged,
  });

  @override
  State<_DeadlineDatePicker> createState() => _DeadlineDatePickerState();
}

class _DeadlineDatePickerState extends State<_DeadlineDatePicker> {
  late final ValueChanged<DateTime?> onDeadlineChanged =
      widget.onDeadlineChanged;

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDeadlineDatePickerTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.finishUntil,
                style: AppTextStyle.bodyText,
              ),
              if (selectedDate != null) ...[
                const SizedBox(height: 10),
                Text(
                  DateFormatters.toDayMonthYear(
                      selectedDate!, context.strings.localeName),
                  style: AppTextStyle.subheadText.copyWith(
                    color: ColorPalette.lightColorBlue,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(
          width: 36,
          height: 20,
          child: Switch(
            onChanged: onDeadlineSwitchChanged,
            value: selectedDate != null,
          ),
        ),
      ],
    );
  }

  Future<void> onDeadlineSwitchChanged(bool value) async {
    if (value) {
      await onDeadlineDatePickerTap(context);
    } else {
      setState(() {
        selectedDate = null;
        onDeadlineChanged(null);
      });
    }
  }

  Future<void> onDeadlineDatePickerTap(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        onDeadlineChanged(date);
      });
    }
  }
}

class _PriorityDropdownButton extends StatefulWidget {
  final ValueChanged<TaskPriority> onPriorityChanged;

  const _PriorityDropdownButton({
    required this.onPriorityChanged,
  });

  @override
  State<_PriorityDropdownButton> createState() =>
      _PriorityDropdownButtonState();
}

class _PriorityDropdownButtonState extends State<_PriorityDropdownButton> {
  TaskPriority selectedPriority = TaskPriority.basic;

  late final ValueChanged<TaskPriority> onPriorityChanged =
      widget.onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: '',
      enableFeedback: false,
      iconSize: 0,
      constraints: const BoxConstraints(minWidth: 164),
      offset: const Offset(0, -20),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TaskPriority.basic,
            child: Text(
              getLocalizedTaskPriority(context, TaskPriority.basic),
              style: AppTextStyle.bodyText,
            ),
          ),
          PopupMenuItem(
            value: TaskPriority.low,
            child: Text(
              getLocalizedTaskPriority(context, TaskPriority.low),
              style: AppTextStyle.bodyText,
            ),
          ),
          PopupMenuItem(
            value: TaskPriority.important,
            child: Text(
              getLocalizedTaskPriority(context, TaskPriority.important),
              style: AppTextStyle.bodyText.copyWith(
                color: ColorPalette.lightColorRed,
              ),
            ),
          ),
        ];
      },
      onSelected: (value) {
        setState(() {
          selectedPriority = value;
          onPriorityChanged(value);
        });
      },
      child: Container(
        height: 28,
        alignment: Alignment.centerLeft,
        child: Text(
          getLocalizedTaskPriority(context, selectedPriority),
          style: AppTextStyle.subheadText,
        ),
      ),
    );
  }

  String getLocalizedTaskPriority(BuildContext context, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.basic:
        return context.strings.none;
      case TaskPriority.low:
        return context.strings.low;
      case TaskPriority.important:
        return context.strings.high;
    }
  }
}

class _DescriptionInputArea extends StatelessWidget {
  const _DescriptionInputArea({
    this.onDescriptionChanged,
  });

  final ValueChanged<String>? onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.taskInputContainer.copyWith(
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: onDescriptionChanged,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: context.strings.whatShouldBeDone,
          hintStyle: AppTextStyle.subheadText.copyWith(
            fontSize: 16,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        style: AppTextStyle.bodyText,
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: null,
      ),
    );
  }
}

class _AddTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSubmit;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const _AddTaskAppBar({
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: AppIcons.closeBlack,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: onSubmit,
          child: Text(
            context.strings.saveCapsed,
            style: AppTextStyle.buttonText.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
