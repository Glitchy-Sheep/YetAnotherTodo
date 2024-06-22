import 'package:flutter/material.dart';
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
            child: Container(
              margin: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TaskDescriptionInputArea(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskDescriptionInputArea extends StatelessWidget {
  const _TaskDescriptionInputArea();

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
