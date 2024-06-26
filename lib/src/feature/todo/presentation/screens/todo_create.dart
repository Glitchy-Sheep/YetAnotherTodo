import 'package:flutter/material.dart';

import '../../../../core/tools/app_localizations_alias.dart';
import '../../../../core/tools/date_formatters.dart';
import '../../../../core/tools/logger.dart';
import '../../../../core/uikit/app_icons.dart';
import '../../../../core/uikit/app_text_style.dart';
import '../../../../core/uikit/colors.dart';
import '../../../../core/uikit/decorations.dart';
import '../../domain/task.dart';

class TodoCreateScreen extends StatelessWidget {
  const TodoCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.ligthBackPrimary,
      appBar: const _AddTaskAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            logger.i('Unfocus textfield');
          },
          child: const SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TodoCreationForm(),
                ),
                SizedBox(height: 20),
                Divider(),
                _DeleteButton(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _DescriptionInputArea(),
        const SizedBox(height: 28),
        Text(
          context.strings.importance,
          style: AppTextStyle.bodyText,
        ),
        const _PriorityDropdownButton(),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        const _DeadlineDatePicker(),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Row(
        children: [
          AppIcons.delete,
          const SizedBox(
            width: 12,
          ),
          Text(
            context.strings.delete,
            style: const TextStyle(
              color: ColorPalette.lightColorRed,
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
  const _DeadlineDatePicker();

  @override
  State<_DeadlineDatePicker> createState() => _DeadlineDatePickerState();
}

class _DeadlineDatePickerState extends State<_DeadlineDatePicker> {
  DateTime? _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onDeadlineDatePickerTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.finishUntil,
                style: AppTextStyle.bodyText,
              ),
              if (_selectedDate != null) ...[
                const SizedBox(height: 10),
                Text(
                  formatDate(_selectedDate!, context.strings.localeName),
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
            onChanged: _onDeadlineSwitchChanged,
            value: _selectedDate != null,
          ),
        ),
      ],
    );
  }

  Future<void> _onDeadlineSwitchChanged(bool value) async {
    if (value) {
      await _onDeadlineDatePickerTap(context);
    } else {
      setState(() {
        _selectedDate = null;
      });
    }
  }

  Future<void> _onDeadlineDatePickerTap(BuildContext context) async {
    final date = await showDatePicker(
      // builder: (context, child) {
      //   // Override theme to match exact color of the date picker
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: const ColorScheme.light(
      //         primary: ColorPalette.lightColorBlue,
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }
}

class _PriorityDropdownButton extends StatefulWidget {
  const _PriorityDropdownButton();

  @override
  State<_PriorityDropdownButton> createState() =>
      _PriorityDropdownButtonState();
}

class _PriorityDropdownButtonState extends State<_PriorityDropdownButton> {
  TaskPriority _selectedPriority = TaskPriority.none;

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
            value: TaskPriority.none,
            child: Text(
              getLocalizedTaskPriority(context, TaskPriority.none),
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
            value: TaskPriority.high,
            child: Text(
              getLocalizedTaskPriority(context, TaskPriority.high),
              style: AppTextStyle.bodyText.copyWith(
                color: ColorPalette.lightColorRed,
              ),
            ),
          ),
        ];
      },
      onSelected: (value) {
        setState(() {
          _selectedPriority = value;
        });
      },
      child: Container(
        height: 28,
        alignment: Alignment.centerLeft,
        child: Text(
          getLocalizedTaskPriority(context, _selectedPriority),
          style: AppTextStyle.subheadText,
        ),
      ),
    );
  }

  String getLocalizedTaskPriority(BuildContext context, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.none:
        return context.strings.none;
      case TaskPriority.low:
        return context.strings.low;
      case TaskPriority.high:
        return context.strings.high;
    }
  }
}

class _DescriptionInputArea extends StatelessWidget {
  const _DescriptionInputArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.taskInputContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: context.strings.whatShouldBeDone,
          hintStyle: AppTextStyle.subheadText.copyWith(fontSize: 16),
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
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const _AddTaskAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorPalette.ligthBackPrimary,
      leading: IconButton(
        icon: AppIcons.closeBlack,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            context.strings.saveCapsed,
            style: AppTextStyle.buttonText.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
