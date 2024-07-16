import 'package:drift/drift.dart';

@DataClassName('RevisionDbModel')
class RevisionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get revision => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
