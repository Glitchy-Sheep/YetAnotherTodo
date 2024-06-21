import 'package:flutter/material.dart';

/// Main screen which shows the list of todos
class TodoViewScreen extends StatelessWidget {
  const TodoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: const Center(
        child: Text('Todo'),
      ),
    );
  }
}
