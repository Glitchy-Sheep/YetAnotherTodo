import 'package:drift/drift.dart';
import '../../../feature/todo/domain/entities/task_entity.dart';

@TableIndex(name: 'todo_is_done', columns: {#isDone})
class TodoItems extends Table {
  TextColumn get id => text()();
  TextColumn get description => text()();
  BoolColumn get isDone => boolean()();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get priority => intEnum<TaskPriority>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get changedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
