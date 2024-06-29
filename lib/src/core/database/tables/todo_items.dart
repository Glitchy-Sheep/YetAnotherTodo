import 'package:drift/drift.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

@TableIndex(name: 'todo_is_done', columns: {#isDone})
class TodoItems extends Table {
  TextColumn get id => text().unique()();
  TextColumn get description => text()();
  BoolColumn get isDone => boolean()();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get priority => intEnum<TaskPriority>()();

  @override
  Set<Column> get primaryKey => {id};
}
