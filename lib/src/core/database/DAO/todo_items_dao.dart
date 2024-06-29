import 'package:drift/drift.dart';
import 'package:yet_another_todo/src/core/database/database_impl.dart';
import 'package:yet_another_todo/src/core/database/tables/todo_items.dart';

part 'todo_items_dao.g.dart';

@DriftAccessor(tables: [TodoItems])
class TodoDao extends DatabaseAccessor<AppDatabaseImpl> with _$TodoDaoMixin {
  final AppDatabaseImpl db;

  // Called by the AppDatabase class
  TodoDao(this.db) : super(db);

  // CRUD Operations

  // Create
  Future<void> insertTodoItem(TodoItem todoItem) =>
      into(todoItems).insert(todoItem);

  // Read
  Future<List<TodoItem>> getAllTodoItems() => select(todoItems).get();

  // Update
  Future<bool> updateTodoItem(TodoItem todoItem) =>
      update(todoItems).replace(todoItem);

  // Delete
  Future<int> deleteTodoItem(TodoItem todoItem) =>
      delete(todoItems).delete(todoItem);
}
