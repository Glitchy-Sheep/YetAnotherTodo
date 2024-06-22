import 'package:flutter/material.dart';
import 'package:yet_another_todo/core/utils/date_formatters.dart';
import 'package:yet_another_todo/core/utils/logger.dart';
import 'package:yet_another_todo/feature/todo/domain/task_priority.dart';
import 'package:yet_another_todo/uikit/app_text_style.dart';
import 'package:yet_another_todo/uikit/colors.dart';

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
            logger.i("Unfocus textfield");
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DescriptionInputArea(),
                      SizedBox(height: 28),
                      Text(
                        "Важность",
                        style: AppTextStyle.bodyText,
                      ),
                      _PriorityDropdownButton(),
                      SizedBox(
                        height: 16,
                      ),
                      Divider(
                        thickness: 1,
                        color: ColorPalette.lightSupportSeparator,
                        height: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      _DeadlineDatePicker(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 1,
                  color: ColorPalette.lightSupportSeparator,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: ColorPalette.lightColorRed,
                          size: 24,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Удалить",
                          style: TextStyle(
                            color: ColorPalette.lightColorRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void _onDeadlineDatePickerTap(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      builder: (context, child) {
        // Override theme to match exact color of the date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorPalette.lightColorBlue,
            ),
          ),
          child: child!,
        );
      },
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
              const Text(
                "Сделать до",
                style: AppTextStyle.bodyText,
              ),
              const SizedBox(
                height: 10,
              ),
              if (_selectedDate != null)
                Text(
                  formatDate(_selectedDate!),
                  style: AppTextStyle.subheadText.copyWith(
                    color: ColorPalette.lightColorBlue,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          width: 36,
          height: 20,
          child: Switch(
            onChanged: (value) {
              if (value) {
                _onDeadlineDatePickerTap(context);
              } else {
                setState(() {
                  _selectedDate = null;
                });
              }
            },
            value: _selectedDate != null,
          ),
        ),
      ],
    );
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
      tooltip: "",
      enableFeedback: false,
      iconSize: 0,
      constraints: const BoxConstraints(minWidth: 164),
      offset: const Offset(0, -20),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: TaskPriority.none,
            child: Text(
              TaskPriority.none.toNameString,
              style: AppTextStyle.bodyText,
            ),
          ),
          PopupMenuItem(
            value: TaskPriority.low,
            child: Text(
              TaskPriority.low.toNameString,
              style: AppTextStyle.bodyText,
            ),
          ),
          PopupMenuItem(
            value: TaskPriority.high,
            child: Text(
              TaskPriority.high.toNameString,
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
          _selectedPriority.toNameString,
          style: const TextStyle(
            color: ColorPalette.lightLabelTertiary,
          ),
        ),
      ),
    );
  }
}

class _DescriptionInputArea extends StatelessWidget {
  const _DescriptionInputArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorPalette.lightBackElevated,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Что надо сделать...",
          hintStyle: AppTextStyle.subheadText.copyWith(fontSize: 16.0),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 7,
        minLines: 4,
      ),
    );
  }
}

class _AddTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AddTaskAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorPalette.ligthBackPrimary,
      leading: IconButton(
        icon: const Icon(
          Icons.close,
          color: ColorPalette.lightLabelPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'СОХРАНИТЬ',
            style: TextStyle(
              color: ColorPalette.lightColorBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
