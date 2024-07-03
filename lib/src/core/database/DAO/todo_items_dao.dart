import 'package:drift/drift.dart';
import '../database_impl.dart';
import '../tables/todo_items.dart';

part 'todo_items_dao.g.dart';

@DriftAccessor(tables: [TodoItems])
class TodoDao extends DatabaseAccessor<AppDatabaseImpl> with _$TodoDaoMixin {
  final AppDatabaseImpl db;

  // Called by the AppDatabase class
  TodoDao(this.db) : super(db);

  // CRUD Operations

  // Create
  Future<void> insertTodoItem(TodoItem todoItem) =>
      into(todoItems).insert(todoItem, mode: InsertMode.insertOrReplace);

  // Read
  Future<List<TodoItem>> getAllTodoItems() => select(todoItems).get();

  Future<TodoItem?> getTodoById(String id) => (select(todoItems)
        ..where(
          (todo) => todo.id.equals(id),
        ))
      .getSingleOrNull();

  // Update
  Future<bool> updateTodoItem(TodoItem todoItem) =>
      update(todoItems).replace(todoItem);

  // Delete
  Future<int> deleteTodoItem(TodoItem todoItem) =>
      delete(todoItems).delete(todoItem);

  Future<int> deleteAll() => delete(todoItems).go();

  Future<void> deleteByTodoId(String id) =>
      (delete(todoItems)..where((tbl) => tbl.id.equals(id))).go();
}
