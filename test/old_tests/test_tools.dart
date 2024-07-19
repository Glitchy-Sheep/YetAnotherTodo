import 'dart:math';

import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

String generateRandomString(int length) {
  final random = Random();
  const characters =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(
      length, (_) => characters[random.nextInt(characters.length)]).join();
}

TaskEntity generateRandomTodoTask() {
  final id = generateRandomString(12);
  final timestamp = DateTime.now();

  return TaskEntity(
    id: id,
    description: 'Test task',
    isDone: false,
    createdAt: timestamp,
    changedAt: timestamp,
  );
}
