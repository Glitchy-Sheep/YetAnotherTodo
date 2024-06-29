import 'package:json_annotation/json_annotation.dart';
import 'package:yet_another_todo/src/feature/todo/data/models/todo_model.dart';

part 'get_todo_list_response.g.dart';

@JsonSerializable()
class GetTodoListResponseModel {
  /// Short description of the response
  final String status;

  /// List of todos
  final List<TodoModel> list;

  /// Revision of the data
  final int revision;

  GetTodoListResponseModel({
    required this.status,
    required this.list,
    required this.revision,
  });

  factory GetTodoListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetTodoListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetTodoListResponseModelToJson(this);
}
