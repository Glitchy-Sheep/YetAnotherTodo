import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/tools/logger.dart';
import '../../../core/tools/uuid_generator.dart';
import '../domain/entities/task_entity.dart';

part 'create_task_form_cubit.freezed.dart';

const String _loggerPrefix = '[CUBIT - CREATE TASK FORM]';

/// Cubit for managing the state of the create task form
class CreateTaskFormCubit extends Cubit<CreateTaskFormState> {
  final TaskEntity? taskToEdit;

  CreateTaskFormCubit({TaskEntity? task})
      : taskToEdit = task,
        super(
          CreateTaskFormState(
            description: task?.description ?? '',
            priority: task?.priority ?? TaskPriority.basic,
            deadline: task?.finishUntil,
          ),
        );

  bool isSubmitAllowed() {
    return state.description.isNotEmpty;
  }

  TaskEntity toTaskEntity() {
    return TaskEntity(
      id: UuidGenerator.v4(),
      description: taskToEdit?.description ?? state.description,
      isDone: taskToEdit?.isDone ?? false,
      priority: taskToEdit?.priority ?? state.priority,
      finishUntil: taskToEdit?.finishUntil ?? state.deadline,
      changedAt: taskToEdit?.changedAt ?? DateTime.now(),
      createdAt: taskToEdit?.createdAt ?? DateTime.now(),
    );
  }

  void onDescriptionChanged(String description) {
    logger.i('$_loggerPrefix: Description changed: $description');
    emit(state.copyWith(description: description));
  }

  void onPriorityChanged(TaskPriority priority) {
    logger.i('$_loggerPrefix: Priority changed: $priority');
    emit(state.copyWith(priority: priority));
  }

  void onDeadlineChanged(DateTime? deadline) {
    logger.i('$_loggerPrefix: Deadline changed: $deadline');
    emit(state.copyWith(deadline: deadline));
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
