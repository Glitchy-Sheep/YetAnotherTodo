// These additional imports are necessary to open the sqlite3 database
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' show sqlite3;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:yet_another_todo/src/core/database/DAO/todo_items_dao.dart';
import 'package:yet_another_todo/src/core/database/tables/todo_items.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

part 'database_impl.g.dart';

@DriftDatabase(
  daos: [
    TodoDao,
  ],
  tables: [
    TodoItems,
  ],
)
class AppDatabaseImpl extends _$AppDatabaseImpl {
  AppDatabaseImpl() : super(_openConnection());

  AppDatabaseImpl.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
