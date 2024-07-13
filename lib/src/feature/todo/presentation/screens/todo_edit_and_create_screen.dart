import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/tools/tools.dart';
import '../../../../core/uikit/uikit.dart';
import '../../../app/di/app_scope.dart';
import '../../bloc/create_task_form/create_task_form_cubit.dart';
import '../../bloc/todo_bloc/todo_bloc.dart';
import '../../domain/entities/task_entity.dart';

@RoutePage()
class TodoEditAndCreateScreen extends StatelessWidget {
  const TodoEditAndCreateScreen({
    super.key,
    this.taskToEdit,
  });

  final String? taskToEdit;

  @override
  Widget build(BuildContext context) {
    final tasksDbRepo = context.appScope.todoDbRepository;

    return BlocProvider(
      create: (context) => CreateTaskFormCubit(
        taskToEditId: taskToEdit,
        todoRepository: tasksDbRepo,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const _AddTaskAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TodoCreationForm(),
                ),
                const SizedBox(height: 20),
                const Divider(),
                _DeleteButton(isActive: taskToEdit != null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoCreationForm extends StatelessWidget {
  const TodoCreationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskFormCubit, CreateTaskFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DescriptionInputArea(description: state.description),
            const SizedBox(height: 28),
            const _PriorityLable(),
            _PriorityDropdownButton(selectedPriority: state.priority),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _DeadlineDatePicker(selectedDate: state.deadline),
          ],
        );
      },
    );
  }
}

class _PriorityLable extends StatelessWidget {
  const _PriorityLable();

  @override
  Widget build(BuildContext context) {
    return Text(context.strings.importance, style: AppTextStyle.bodyText);
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
      onPressed: isActive ? () => _onDeletePressed(context) : null,
      child: Row(
        children: [
          // Workaround for color change
          Icon(Icons.delete, color: color),
          const SizedBox(width: 12),
          Text(
            context.strings.delete,
            style: AppTextStyle.bodyText.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _onDeletePressed(BuildContext context) {
    final todoBloc = context.appScope.todoBloc;
    final todoToDelete = context.read<CreateTaskFormCubit>().toTaskEntity();

    todoBloc.add(
      TodoEvent.deleteTodo(
        todoToDelete.id,
      ),
    );

    context.router.maybePop();
  }
}

class _DeadlineDatePicker extends StatelessWidget {
  const _DeadlineDatePicker({
    required this.selectedDate,
  });

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final currentDate = selectedDate;

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
              if (currentDate != null) ...[
                const SizedBox(height: 10),
                Text(
                  DateFormatters.toDayMonthYear(
                    currentDate,
                    context.strings.localeName,
                  ),
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
            onChanged: (newValue) => onDeadlineSwitchChanged(
              context,
              newValue: newValue,
            ),
            value: selectedDate != null,
          ),
        ),
      ],
    );
  }

  Future<void> onDeadlineSwitchChanged(BuildContext context,
      {required bool newValue}) async {
    if (newValue) {
      await onDeadlineDatePickerTap(context);
    } else {
      context.read<CreateTaskFormCubit>().onDeadlineChanged(null);
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
      if (context.mounted) {
        context.read<CreateTaskFormCubit>().onDeadlineChanged(date);
      }
    }
  }
}

class _PriorityDropdownButton extends StatelessWidget {
  const _PriorityDropdownButton({
    required this.selectedPriority,
  });

  final TaskPriority selectedPriority;

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
      onSelected: context.read<CreateTaskFormCubit>().onPriorityChanged,
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

class _DescriptionInputArea extends StatefulWidget {
  final String description;

  const _DescriptionInputArea({
    required this.description,
  });

  @override
  State<_DescriptionInputArea> createState() => _DescriptionInputAreaState();
}

class _DescriptionInputAreaState extends State<_DescriptionInputArea> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.taskInputContainer.copyWith(
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocListener<CreateTaskFormCubit, CreateTaskFormState>(
        listener: (context, state) {
          setState(() {
            controller.text = state.description;
          });
        },
        child: TextFormField(
          controller: controller,
          onChanged: context.read<CreateTaskFormCubit>().onDescriptionChanged,
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
      ),
    );
  }
}

class _AddTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const _AddTaskAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: AppIcons.closeBlack,
        onPressed: () => context.router.maybePop(),
      ),
      actions: [
        TextButton(
          onPressed: () => onSubmit(context),
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

  void onSubmit(BuildContext context) {
    final formCubit = context.read<CreateTaskFormCubit>();

    if (formCubit.isSubmitAllowed()) {
      final todoToAdd = formCubit.toTaskEntity();

      AppScope.of(context).todoBloc
        ..add(
          TodoEvent.addTodo(todoToAdd),
        )
        ..add(
          const TodoEvent.loadTodos(),
        );
      Navigator.of(context).pop();
    }
  }
}
