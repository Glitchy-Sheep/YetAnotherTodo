import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yet_another_todo/src/core/database/database_impl.dart';
import 'package:yet_another_todo/src/core/tools/logger.dart';

import 'test_tools.dart';

void main() async {
  late AppDatabaseImpl db;

  setUpAll(() async {
    db = AppDatabaseImpl.forTesting(NativeDatabase.memory());
  });

  tearDownAll(() async {
    await db.close();
  });

  tearDown(() async {
    logger.i('-' * 40);
  });

  test('add todo', () async {
    const loggerPrefix = '[ADD TODO TEST]';
    final newTodo = generateRandomTodoTask();

    logger.i('$loggerPrefix: Generated todo with id ${newTodo.id}');

    await db.todoDao.insertTodoItem(
      TodoDbModel(
        id: newTodo.id,
        description: newTodo.description,
        isDone: newTodo.isDone,
        priority: newTodo.priority,
        createdAt: newTodo.createdAt,
        changedAt: newTodo.changedAt,
      ),
    );

    logger.i('$loggerPrefix: Todo ${newTodo.id} inserted in db');
    final insertedTodo = await db.todoDao.getTodoById(newTodo.id);
    expect(insertedTodo?.id, newTodo.id);
  });

  test('edit todo', () async {
    const loggerPrefix = '[EDIT TODO TEST]';

    final newTodo = generateRandomTodoTask();
    await db.todoDao.insertTodoItem(
      TodoDbModel(
        id: newTodo.id,
        description: newTodo.description,
        isDone: newTodo.isDone,
        priority: newTodo.priority,
        createdAt: newTodo.createdAt,
        changedAt: newTodo.changedAt,
      ),
    );

    logger.i('$loggerPrefix: Created test todo with id ${newTodo.id}');

    final todoBeforeEdit = await db.todoDao.getTodoById(newTodo.id);
    final todoIsDoneBeforeEdit = todoBeforeEdit!.isDone;

    logger.i('$loggerPrefix: Trying to edit todo');

    final editedTodo = newTodo.copyWith(
      isDone: !newTodo.isDone,
    );

    await db.todoDao.updateTodoItem(TodoDbModel(
      id: newTodo.id,
      description: editedTodo.description,
      isDone: editedTodo.isDone,
      priority: editedTodo.priority,
      createdAt: editedTodo.createdAt,
      changedAt: editedTodo.changedAt,
    ));

    final todoAfterEdit = await db.todoDao.getTodoById(newTodo.id);
    expect(todoAfterEdit!.isDone, editedTodo.isDone);
    expect(todoAfterEdit.isDone, !todoIsDoneBeforeEdit);

    logger.i('$loggerPrefix: Todo edited successfully');
  });

  test('delete todo', () async {
    const loggerPrefix = '[DELETE TODO TEST]';

    final newTodo = generateRandomTodoTask();

    await db.todoDao.insertTodoItem(
      TodoDbModel(
        id: newTodo.id,
        description: newTodo.description,
        isDone: newTodo.isDone,
        priority: newTodo.priority,
        createdAt: newTodo.createdAt,
        changedAt: newTodo.changedAt,
      ),
    );

    final insertedTodo = await db.todoDao.getTodoById(newTodo.id);
    expect(insertedTodo, isNotNull);

    logger.i('$loggerPrefix: Created test todo with id ${newTodo.id}');

    await db.todoDao.deleteTodoItem(insertedTodo!);
    logger.i('$loggerPrefix: Trying to delete todo');

    final deletedTodo = await db.todoDao.getTodoById(newTodo.id);
    expect(deletedTodo, isNull);

    logger.i('$loggerPrefix: Todo deleted successfully');
  });

  test(
    'delete todo by id',
    () async {
      const loggerPrefix = '[DELETE BY ID TODO TEST]';

      final newTodo = generateRandomTodoTask();
      await db.todoDao.insertTodoItem(
        TodoDbModel(
          id: newTodo.id,
          description: newTodo.description,
          isDone: newTodo.isDone,
          priority: newTodo.priority,
          createdAt: newTodo.createdAt,
          changedAt: newTodo.changedAt,
        ),
      );

      logger.i('$loggerPrefix: Created test todo with id ${newTodo.id}');

      final insertedTodo = await db.todoDao.getTodoById(newTodo.id);
      expect(insertedTodo, isNotNull);

      await db.todoDao.deleteByTodoId(newTodo.id);
      logger.i('$loggerPrefix: Deleting test todo by id ${newTodo.id}');

      final deletedTodo = await db.todoDao.getTodoById(newTodo.id);
      expect(deletedTodo, isNull);
      logger.i('$loggerPrefix: Todo deleted successfully');
    },
  );
}
