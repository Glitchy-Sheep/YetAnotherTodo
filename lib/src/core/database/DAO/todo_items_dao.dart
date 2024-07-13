import 'package:drift/drift.dart';
import '../database_impl.dart';
import '../tables/todo_items.dart';

part 'todo_items_dao.g.dart';

@DriftAccessor(tables: [TodoTable])
class TodoDao extends DatabaseAccessor<AppDatabaseImpl> with _$TodoDaoMixin {
  final AppDatabaseImpl db;

  TodoDao(this.db) : super(db);

  /// -----------------------
  /// Create
  /// -----------------------
  Future<TodoDbModel> insertTodoItem(TodoDbModel todoItem) async =>
      into(todoTable).insertReturning(
        todoItem,
        mode: InsertMode.insertOrReplace,
      );

  Future<void> insertTodoItems(List<TodoDbModel> itemsToInsert) async =>
      // Using batch for performance
      batch((batch) {
        batch.insertAll(
          todoTable,
          itemsToInsert,
          mode: InsertMode.insertOrReplace,
        );
      });

  /// -----------------------
  /// Read
  /// -----------------------
  Future<List<TodoDbModel>> getAllTodoItems() async => select(todoTable).get();

  Future<TodoDbModel?> getTodoById(String id) async => (select(todoTable)
        ..where(
          (todo) => todo.id.equals(id),
        ))
      .getSingleOrNull();

  /// -----------------------
  /// Update
  /// -----------------------
  Future<bool> updateTodoItem(TodoDbModel todoItem) async =>
      update(todoTable).replace(todoItem);

  /// -----------------------
  /// Delete
  /// -----------------------
  Future<int> deleteTodoItem(TodoDbModel todoItem) async =>
      delete(todoTable).delete(todoItem);

  Future<int> deleteAll() async => delete(todoTable).go();

  Future<void> deleteByTodoId(String id) async => (delete(todoTable)
        ..where(
          (tbl) => tbl.id.equals(id),
        ))
      .go();
}
