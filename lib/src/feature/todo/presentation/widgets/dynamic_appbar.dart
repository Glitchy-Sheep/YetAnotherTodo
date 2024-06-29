import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yet_another_todo/src/feature/app/di/app_scope.dart';
import 'package:yet_another_todo/src/feature/app/preferences.dart';
import 'package:yet_another_todo/src/feature/todo/bloc/todo_bloc.dart';

import '../../../../core/tools/app_localizations_alias.dart';
import '../../../../core/uikit/app_icons.dart';

class DynamicSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final ValueNotifier<bool> completedTasksVisibility;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  DynamicSliverAppBar({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.completedTasksVisibility,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppBar(
          scrolledUnderElevation: 4,
          backgroundColor: Color.lerp(
            Theme.of(context).appBarTheme.backgroundColor,
            Theme.of(context).appBarTheme.surfaceTintColor,
            (1 - (shrinkOffset / expandedHeight)).clamp(0, 1),
          ),
        ),
        Positioned(
          bottom: (46 - shrinkOffset).clamp(16, 46),
          left: (60 - shrinkOffset).clamp(16, 60),
          child: Text(
            context.strings.myTodos,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: (32 - shrinkOffset / 3).clamp(20, 32),
                ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 60,
              bottom: 16,
            ),
            child: Opacity(
              opacity: (1 - shrinkOffset / 20).clamp(0, 1),
              child: BlocBuilder<TodoBloc, TodoState>(
                bloc: AppScope.of(context).todoBloc,
                builder: (context, state) {
                  return state.mapOrNull(
                        tasksLoaded: (value) => Text(
                          '${context.strings.done} - ${value.tasks.where((t) => t.isDone).length}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ) ??
                      Container();

                  // return Text(
                  //   '${context.strings.done} - 10',
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // );
                },
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 0,
          child: VisibilityButton(
            completedTasksVisibility: completedTasksVisibility,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class VisibilityButton extends StatefulWidget {
  final ValueNotifier<bool> completedTasksVisibility;

  const VisibilityButton({required this.completedTasksVisibility, super.key});

  @override
  State<VisibilityButton> createState() => _VisibilityButtonState();
}

class _VisibilityButtonState extends State<VisibilityButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(
          () {
            // Seems messy, should be refactored
            context.preferences.toggleCompletedTasksVissible();
            widget.completedTasksVisibility.value =
                !widget.completedTasksVisibility.value;
          },
        );
      },
      icon: widget.completedTasksVisibility.value
          ? AppIcons.visibleIcon
          : AppIcons.hiddenIcon,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
