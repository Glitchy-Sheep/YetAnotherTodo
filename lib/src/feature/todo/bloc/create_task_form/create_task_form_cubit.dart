import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/tools/tools.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/db_todo_repository.dart';

part 'create_task_form_cubit.freezed.dart';

const String _loggerPrefix = '[CUBIT - CREATE TASK FORM]';

class CreateTaskFormCubit extends Cubit<CreateTaskFormState> {
  final String? taskToEditId;
  final TodoRepositoryDb todoRepository;

  static const _defaultFormState = CreateTaskFormState(
    description: '',
    priority: TaskPriority.basic,
  );

  CreateTaskFormCubit({
    required this.todoRepository,
    this.taskToEditId,
  }) : super(_defaultFormState) {
    _init();
  }

  Future<void> _init() async {
    final taskId = taskToEditId;

    if (taskId != null) {
      final task = await todoRepository.getTodoById(taskId);
      if (task == null) {
        throw Exception('Task with id $taskId not found');
      }

      emit(
        CreateTaskFormState(
          description: task.description,
          priority: task.priority,
          deadline: task.finishUntil,
        ),
      );
    }
  }

  bool isSubmitAllowed() {
    return state.description.isNotEmpty;
  }

  TaskEntity toTaskEntity() {
    return TaskEntity(
      id: UuidGenerator.v4(),
      description: state.description,
      isDone: false, // Assuming default value, adjust as necessary
      priority: state.priority,
      finishUntil: state.deadline,
      changedAt: DateTime.now(), // Assuming default value, adjust as necessary
      createdAt: DateTime.now(), // Assuming default value, adjust as necessary
    );
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void onPriorityChanged(TaskPriority value) {
    emit(state.copyWith(priority: value));
  }

  void onDeadlineChanged(DateTime? value) {
    emit(state.copyWith(deadline: value));
  }
}

@freezed
class CreateTaskFormState with _$CreateTaskFormState {
  const CreateTaskFormState._();

  // Default form state
  const factory CreateTaskFormState({
    required String description,
    required TaskPriority priority,
    DateTime? deadline,
  }) = _CreateTaskFormState;
}
