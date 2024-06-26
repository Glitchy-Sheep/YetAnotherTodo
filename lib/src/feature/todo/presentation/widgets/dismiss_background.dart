import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  final Color dismissColor;

  const DismissBackground({
    required this.dismissColor,
    required this.alignment,
    required this.child,
    super.key,
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
