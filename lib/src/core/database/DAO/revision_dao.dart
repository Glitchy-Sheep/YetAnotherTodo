import 'package:drift/drift.dart';
import '../database_impl.dart';
import '../tables/revision.dart';

part 'revision_dao.g.dart';

@DriftAccessor(tables: [RevisionTable])
class RevisionDao extends DatabaseAccessor<AppDatabaseImpl>
    with _$RevisionDaoMixin {
  final AppDatabaseImpl db;

  RevisionDao(this.db) : super(db);

  Future<int> getRevision() async {
    final query = select(revisionTable)..limit(1);
    final result = await query.getSingleOrNull();
    return result?.revision ?? 0;
  }

  Future<void> setRevision(int newRevision) async {
    await delete(revisionTable).go();
    await into(revisionTable).insert(
      RevisionDbModel(
        id: 0,
        revision: newRevision,
      ),
    );
  }

  // Just a shortcut to increase revision
  Future<void> increaseRevision() async {
    final currentRevision = await getRevision();
    await setRevision(currentRevision + 1);
  }
}
