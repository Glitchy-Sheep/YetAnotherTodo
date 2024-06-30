import 'package:yet_another_todo/src/core/database/database_impl.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';
import 'package:yet_another_todo/src/feature/todo/domain/repository/db_todo_repository.dart';

class TodoRepositoryDbImpl implements TodoRepositoryDb {
  final AppDatabaseImpl _db;

  TodoRepositoryDbImpl(this._db);

  @override
  Future<void> addTodo(TaskEntity todo) async {
    await _db.todoDao.insertTodoItem(
      TodoItem(
        id: todo.id,
        description: todo.description,
        isDone: todo.isDone,
        priority: todo.priority,
        deadline: todo.finishUntil,
      ),
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _db.todoDao.deleteByTodoId(id);
  }

  @override
  Future<void> editTodo(String id, TaskEntity todo) async {
    await _db.todoDao.updateTodoItem(
      TodoItem(
        id: id,
        description: todo.description,
        isDone: todo.isDone,
        priority: todo.priority,
        deadline: todo.finishUntil,
      ),
    );
  }

  @override
  Future<TaskEntity?> getTodoById(String id) async {
    final todo = await _db.todoDao.getTodoById(id);
    if (todo == null) {
      return null;
    }

    return TaskEntity(
      id: todo.id,
      description: todo.description,
      isDone: todo.isDone,
      priority: todo.priority,
      finishUntil: todo.deadline,
    );
  }

  @override
  Future<List<TaskEntity>> getTodos() async {
    final todos = await _db.todoDao.getAllTodoItems();

    return todos
        .map(
          (todoItem) => TaskEntity(
            id: todoItem.id,
            description: todoItem.description,
            isDone: todoItem.isDone,
            finishUntil: todoItem.deadline,
            priority: todoItem.priority,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteAllTodos() {
    return _db.todoDao.deleteAll();
  }
}
