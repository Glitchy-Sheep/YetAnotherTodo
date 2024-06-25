import 'package:flutter/material.dart';
import 'package:yet_another_todo/feature/todo/domain/task.dart';
import 'package:yet_another_todo/feature/todo/presentation/screens/todo_create.dart';
import 'package:yet_another_todo/feature/todo/presentation/widgets/task_tile.dart';
import 'package:yet_another_todo/uikit/app_text_style.dart';
import 'package:yet_another_todo/uikit/colors.dart';

const _eyeIcon = Icon(
  Icons.remove_red_eye,
  size: 24,
  color: ColorPalette.lightColorBlue,
);

/// Main screen which shows the list of todos
class TodoViewScreen extends StatelessWidget {
  const TodoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _AddTaskButton(
        onPressed: () => onAddTaskPressed(context),
      ),
      backgroundColor: ColorPalette.ligthBackPrimary,
      body: const SafeArea(
        child: CustomScrollView(
          slivers: [
            _TasksAppBar(),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: _TaskList(),
            ),
          ],
        ),
      ),
    );
  }

  void onAddTaskPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<TodoCreateScreen>(
        builder: (context) => const TodoCreateScreen(),
      ),
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _AddTaskButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: ColorPalette.lightColorBlue,
          child: const Icon(
            Icons.add,
            color: ColorPalette.lightColorWhite,
          ),
        ),
      ),
    );
  }
}

class _TasksAppBar extends StatelessWidget {
  static const _appBarSpaceHeight = 164.0;
  static const _appBarCollapsedHeight = 88.0;
  static const _appBarCollapseContentHeight = 80.0;

  const _TasksAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      shadowColor: Colors.black,
      collapsedHeight: _appBarCollapsedHeight,
      expandedHeight: _appBarSpaceHeight,
      backgroundColor: ColorPalette.ligthBackPrimary,
      surfaceTintColor: ColorPalette.ligthBackPrimary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        title: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.biggest.height >= _appBarCollapseContentHeight) {
              return const _AppBarFullContent();
            } else {
              return const _AppBarCollapsedContent();
            }
          },
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList();

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: const BoxDecoration(
        color: ColorPalette.lightBackElevated,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      // Infinite list as a stub for the first stage
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            // Some stub data to show all the cases
            final TaskPriority priority;
            if (index % 3 == 0) {
              priority = TaskPriority.high;
            } else if (index % 4 == 0) {
              priority = TaskPriority.low;
            } else {
              priority = TaskPriority.none;
            }

            return TaskTile(
              task: TaskEntity(
                id: 1,
                description: 'Нажать на галочку',
                isDone: index % 2 == 0 ? true : false,
                finishUntil: index % 3 == 0 ? DateTime.now() : null,
                priority: priority,
              ),
              onCheck: (newValue) {},
            );
          },
        ),
      ),
    );
  }
}

// The sliver app bar content when it is collapsed
class _AppBarCollapsedContent extends StatelessWidget {
  const _AppBarCollapsedContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Мои дела',
            style: AppTextStyle.mediumTitle,
          ),
          _eyeIcon,
        ],
      ),
    );
  }
}

// The sliver app bar content when it's expanded
class _AppBarFullContent extends StatelessWidget {
  const _AppBarFullContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.only(
        start: 60,
        end: 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Мои дела',
            style: AppTextStyle.largeTitle,
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Выполнено - 5',
                style: AppTextStyle.subheadText,
              ),
              _eyeIcon,
            ],
          ),
        ],
      ),
    );
  }
}
