import 'package:drift/drift.dart';
import '../database_impl.dart';
import '../tables/todo_items.dart';

part 'todo_items_dao.g.dart';

@DriftAccessor(tables: [TodoItems])
class TodoDao extends DatabaseAccessor<AppDatabaseImpl> with _$TodoDaoMixin {
  final AppDatabaseImpl db;

  TodoDao(this.db) : super(db);

  Future<void> insertTodoItem(TodoItem todoItem) async =>
      into(todoItems).insert(
        todoItem,
        mode: InsertMode.insertOrReplace,
      );

  Future<void> insertTodoItems(List<TodoItem> itemsToInsert) async =>
      batch((batch) {
        batch.insertAll(
          todoItems,
          itemsToInsert,
          mode: InsertMode.insertOrReplace,
        );
      });

  // Read
  Future<List<TodoItem>> getAllTodoItems() async => select(todoItems).get();

  Future<TodoItem?> getTodoById(String id) async => (select(todoItems)
        ..where(
          (todo) => todo.id.equals(id),
        ))
      .getSingleOrNull();

  // Update
  Future<bool> updateTodoItem(TodoItem todoItem) async =>
      update(todoItems).replace(todoItem);

  // Delete
  Future<int> deleteTodoItem(TodoItem todoItem) async =>
      delete(todoItems).delete(todoItem);

  Future<int> deleteAll() async => delete(todoItems).go();

  Future<void> deleteByTodoId(String id) async =>
      (delete(todoItems)..where((tbl) => tbl.id.equals(id))).go();
}
