import 'package:json_annotation/json_annotation.dart';
import 'package:yet_another_todo/src/feature/todo/domain/entities/task_entity.dart';

part 'todo_model.g.dart';

/// "Todo" model to get data from server
@JsonSerializable()
class TodoModel {
  /// Unique id (in UUID format) for the element
  final String id;

  /// Text of the task
  final String text;

  /// Priority of the task = low | basic | important
  final TaskPriority importance;

  /// Deadline of the task, may be null
  @JsonKey(
    name: 'deadline',
    fromJson: _maybeUnixFromDatetime,
    toJson: _maybeDatetimeFromUnix,
  )
  final DateTime? deadline;

  /// Is the task mark as done
  @JsonKey(name: 'done')
  final bool isDone;

  /// Optional color field
  final String? color;

  @JsonKey(
    name: 'created_at',
    fromJson: DateTime.fromMillisecondsSinceEpoch,
    toJson: _unixFromDatetime,
  )
  final DateTime createdAtUnixTimestamp;
  @JsonKey(
    name: 'changed_at',
    fromJson: DateTime.fromMillisecondsSinceEpoch,
    toJson: _unixFromDatetime,
  )
  final DateTime changedAtUnixTimestamp;

  /// Unique id for the device
  @JsonKey(name: 'last_updated_by')
  final String lastUpdatedBy;

  TodoModel({
    required this.id,
    required this.text,
    required this.importance,
    required this.deadline,
    required this.isDone,
    required this.color,
    required this.createdAtUnixTimestamp,
    required this.changedAtUnixTimestamp,
    required this.lastUpdatedBy,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  // ----------------------------
  //          Converters
  // ----------------------------
  // Unfortunately there is no way to create
  // unique function for convertering nullable and not nullable types
  // maybe if json_serializable would have some tool/option
  // to bypass fromJson if type is nullable, it could be possible
  static DateTime? _maybeUnixFromDatetime(int? timestamp) {
    if (timestamp == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static int? _maybeDatetimeFromUnix(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return dateTime.millisecondsSinceEpoch;
  }

  static int _unixFromDatetime(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }
}
