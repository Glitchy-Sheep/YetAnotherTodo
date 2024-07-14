import '../../../../core/database/database_impl.dart';
import '../../../../core/tools/logger.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/db_todo_repository.dart';
import '../mappers/task_mapper.dart';

const _loggerPrefix = '[REPOSITORY - DB]';

class TodoDbRepositoryImpl implements TodoDbRepository {
  final AppDatabaseImpl _db;

  TodoDbRepositoryImpl(this._db);

  @override
  Future<TaskEntity> addTodo(TaskEntity todo) async {
    final insertedTodo = await _db.todoDao.insertTodoItem(
      TaskMapper.fromEntityToDbModel(todo),
    );

    return TaskMapper.fromDbModelToEntity(
      insertedTodo,
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _db.todoDao.deleteByTodoId(id);
  }

  @override
  Future<void> editTodo(String id, TaskEntity todo) async {
    await _db.todoDao.updateTodoItem(
      TodoDbModel(
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
  Future<void> deleteAllTodos() async {
    await _db.todoDao.deleteAll();
  }

  @override
  Future<int> getRevision() async {
    return _db.revisionDao.getRevision();
  }

  @override
  Future<void> increaseRevision() async {
    logger.i(
        '$_loggerPrefix: Revision incresased - ${await _db.revisionDao.getRevision()}');
    await _db.revisionDao.increaseRevision();
  }

  @override
  Future<void> setRevision(int newRevisionValue) async {
    await _db.revisionDao.setRevision(newRevisionValue);
  }
}
