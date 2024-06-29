import 'package:json_annotation/json_annotation.dart';
import 'package:yet_another_todo/src/feature/todo/data/models/todo_model.dart';

part 'get_todo_by_id_response.g.dart';

@JsonSerializable()
class GetTodoByIdResponseModel {
  /// Short description of the response
  final String status;

  /// List of todos
  final TodoModel element;

  /// Revision of the data
  final int revision;

  GetTodoByIdResponseModel({
    required this.status,
    required this.element,
    required this.revision,
  });

  factory GetTodoByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetTodoByIdResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetTodoByIdResponseModelToJson(this);
}
