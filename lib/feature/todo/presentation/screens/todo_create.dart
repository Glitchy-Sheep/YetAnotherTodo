import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yet_another_todo/core/utils/logger.dart';
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _DescriptionInputArea(),
                      const SizedBox(height: 28),
                      Text(
                        "Важность",
                        style: AppTextStyle.bodyText.value,
                      ),
                      const _PriorityDropdownButton(),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.lightSupportSeparator,
                        height: 16,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const _DeadlineDatePicker(),
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

  String formatDate(DateTime date) {
    return DateFormat(
      'dd MMMM yyyy',
      'ru',
    ).format(date);
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
              Text(
                "Сделать до",
                style: AppTextStyle.bodyText.value,
              ),
              const SizedBox(
                height: 10,
              ),
              if (_selectedDate != null)
                Text(
                  formatDate(_selectedDate!),
                  style: AppTextStyle.subheadText.value.copyWith(
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

class _PriorityDropdownButton extends StatelessWidget {
  const _PriorityDropdownButton();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 164,
      expandedInsets: const EdgeInsets.all(0),
      textStyle: AppTextStyle.subheadText.value,
      trailingIcon: const Visibility(
        // bruh
        visible: false,
        child: Icon(Icons.arrow_drop_down),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        isDense: false,
        constraints: BoxConstraints.tight(
          const Size.fromHeight(22),
        ),
      ),
      dropdownMenuEntries: [
        const DropdownMenuEntry(
          label: "Нет",
          value: null,
        ),
        const DropdownMenuEntry(
          label: "Низкий",
          value: null,
        ),
        DropdownMenuEntry(
          label: "!! Высокий",
          value: null,
          style: MenuItemButton.styleFrom(
            textStyle: const TextStyle(
              color: ColorPalette.lightColorRed,
            ),
          ),
        ),
      ],
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
          hintStyle: AppTextStyle.subheadText.value.copyWith(fontSize: 16.0),
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
