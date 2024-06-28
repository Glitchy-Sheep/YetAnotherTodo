import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

/// "Todo" model to get data from server
@JsonSerializable()
class TodoModel {
  /// Unique id (in UUID format) for the element
  final String id;

  /// Text of the task
  final String text;

  /// Priority of the task = low | basic | important
  final String importance;

  /// Deadline of the task, may be null
  final DateTime? deadline;

  /// Is the task mark as done
  @JsonKey(name: 'done')
  final bool isDone;

  /// Optional color field
  final String? color;

  @JsonKey(name: 'created_at')
  final int createdAtUnixTimestamp;
  @JsonKey(name: 'changed_at')
  final int changedAtUnixTimestamp;

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
}
