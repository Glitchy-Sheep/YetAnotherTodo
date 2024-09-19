import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_entity.dart';

part 'all_remote_tasks_entity.freezed.dart';

@freezed
class AllRemoteTasksEntity with _$AllRemoteTasksEntity {
  const factory AllRemoteTasksEntity({
    required List<TaskEntity> tasks,
    required int revision,
  }) = _AllRemoteTasksEntity;
}
