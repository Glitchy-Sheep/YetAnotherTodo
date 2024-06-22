import 'package:flutter/material.dart';
import 'package:yet_another_todo/uikit/colors.dart';

class TodoCreateScreen extends StatelessWidget {
  const TodoCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AddTaskAppBar(),
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
