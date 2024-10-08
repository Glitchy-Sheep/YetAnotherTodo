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
    enableLog: false,
  );

  final tasksRepository = TodoRepositoryApiImpl(
    baseDioClient: dio,
  );

  test('get todos', () async {
    const loggerPrefix = '[GET TODO TEST]';
    final todos = await tasksRepository.getTodos();

    expect(todos, isA<List<TaskEntity>>());
    logger.i('$loggerPrefix: GOT DATA - $todos');
  });

  test('create todo', () async {
    final newTodo = generateRandomTodoTask();
    await tasksRepository.addTodo(newTodo);
    // final todos = await tasksRepository.getTodos();
    // expect(todos, contains(newTodo));
  });

  test('delete todo', () async {
    const loggerPrefix = '[DELETE TODO TEST]';

    logger.i('$loggerPrefix: generating task data');
    final todoToDelete = generateRandomTodoTask();

    logger.i('$loggerPrefix: add task to the backend');
    await tasksRepository.addTodo(todoToDelete);

    final allTasks = await tasksRepository.getTodos();
    expect(allTasks, contains(todoToDelete));

    logger.i('$loggerPrefix: delete task from the backend');
    await tasksRepository.deleteTodo(todoToDelete.id);

    logger.i('$loggerPrefix: delete task from the backend');
    final todosAfterDelete = await tasksRepository.getTodos();

    expect(todosAfterDelete, isNot(contains(todoToDelete)));
  });

  test('edit todo', () async {
    const loggerPrefix = '[EDIT TODO TEST]';

    final todoToEdit = generateRandomTodoTask();

    logger.i('$loggerPrefix: adding task to the backend');
    await tasksRepository.addTodo(todoToEdit);

    logger.i('$loggerPrefix: get updated tasks on the backend');
    final allTasks = await tasksRepository.getTodos();
    expect(allTasks, contains(todoToEdit));

    final isDoneBeforeUpdate = todoToEdit.isDone;
    final expectedIsDoneAfterUpdate = !isDoneBeforeUpdate;
    final editedTodo = todoToEdit.copyWith(isDone: expectedIsDoneAfterUpdate);

    logger.i('$loggerPrefix: edit task on the backend');
    await tasksRepository.editTodo(todoToEdit.id, editedTodo);

    logger.i('$loggerPrefix: get updated tasks on the backend');
    final allTasksAfterEdit = await tasksRepository.getTodos();
    final updatedTask = allTasksAfterEdit.firstWhere(
      (element) => element.id == todoToEdit.id,
    );
    expect(updatedTask.isDone, expectedIsDoneAfterUpdate);
    logger.i(
      'task.isDone updated successfully from $isDoneBeforeUpdate -> $expectedIsDoneAfterUpdate',
    );
  });

  test('delete all todos', () async {
    final allTodos = await tasksRepository.getTodos();
    for (final todo in allTodos) {
      await tasksRepository.deleteTodo(todo.id);
      logger.i('Deleted: $todo.id - ${todo.description}');
    }
  });
}
