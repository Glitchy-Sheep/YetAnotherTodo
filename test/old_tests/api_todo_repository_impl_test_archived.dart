import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yet_another_todo/src/core/api/dio_configuration.dart';
import 'package:yet_another_todo/src/core/api/interceptors/auth_interceptor.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';
import 'package:yet_another_todo/src/feature/todo/data/repository/api_todo_repository_impl.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

import 'test_tools.dart';

void main() async {
  // Init config files
  await dotenv.load(fileName: 'config.env');

  final dio = AppDioConfigurator.create(
    interceptors: [
      AuthDioInterceptor(
        token: dotenv.env['API_TOKEN']!,
      ),
    ],
    url: dotenv.env['API_BASE_URL']!,
  );

  final tasksRepository = TodoApiRepositoryImpl(
    baseDioClient: dio,
    // You can pass the revision as a callback
    // pretty simple solution, testable and interchangable
    lastKnownRevisionGetter: () async {
      return 0;
    },
  );

  test('get todos', () async {
    const loggerPrefix = '[GET TODO TEST]';
    final todos = await tasksRepository.getTodos();

    expect(todos.tasks, isA<List<TaskEntity>>());
    logger.i('$loggerPrefix: GOT DATA - $todos');
  });

  test('create todo', () async {
    final newTodo = generateRandomTodoTask();
    await tasksRepository.addTodo(newTodo);
    final todos = await tasksRepository.getTodos();
    expect(todos.tasks, contains(newTodo));
  });

  test('delete todo', () async {
    const loggerPrefix = '[DELETE TODO TEST]';

    final todoToDelete = generateRandomTodoTask();
    logger.i('$loggerPrefix: generated task - $todoToDelete');

    await tasksRepository.addTodo(todoToDelete);
    logger.i('$loggerPrefix: pushed the task to backend');

    final allTasks = await tasksRepository.getTodos();
    expect(allTasks.tasks, contains(todoToDelete));

    await tasksRepository.deleteTodo(todoToDelete.id);
    logger.i('$loggerPrefix: deleted the task from backend');

    final allTasksAfterDelete = await tasksRepository.getTodos();
    expect(allTasksAfterDelete.tasks, isNot(contains(todoToDelete)));
  });

  test('edit todo', () async {
    const loggerPrefix = '[EDIT TODO TEST]';

    final todoToEdit = generateRandomTodoTask();

    logger.i('$loggerPrefix: adding task to the backend');
    await tasksRepository.addTodo(todoToEdit);

    logger.i('$loggerPrefix: get updated tasks on the backend');
    final allTasks = await tasksRepository.getTodos();
    expect(allTasks.tasks, contains(todoToEdit));

    final isDoneBeforeUpdate = todoToEdit.isDone;
    final expectedIsDoneAfterUpdate = !isDoneBeforeUpdate;
    final editedTodo = todoToEdit.copyWith(isDone: expectedIsDoneAfterUpdate);

    logger.i('$loggerPrefix: edit task on the backend');
    await tasksRepository.editTodo(todoToEdit.id, editedTodo);

    logger.i('$loggerPrefix: get updated tasks on the backend');
    final allTasksAfterEdit = await tasksRepository.getTodos();
    final updatedTask = allTasksAfterEdit.tasks.firstWhere(
      (element) => element.id == todoToEdit.id,
    );
    expect(updatedTask.isDone, expectedIsDoneAfterUpdate);
    logger.i(
      'task.isDone updated successfully from $isDoneBeforeUpdate -> $expectedIsDoneAfterUpdate',
    );
  });
}
