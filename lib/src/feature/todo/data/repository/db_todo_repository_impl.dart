import '../../../../core/database/database_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/db_todo_repository.dart';

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
        createdAt: todo.createdAt,
        changedAt: todo.changedAt,
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
        createdAt: todo.createdAt,
        changedAt: todo.changedAt,
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
      createdAt: todo.createdAt,
      changedAt: todo.changedAt,
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
            createdAt: todoItem.createdAt,
            changedAt: todoItem.changedAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteAllTodos() {
    return _db.todoDao.deleteAll();
  }
}
