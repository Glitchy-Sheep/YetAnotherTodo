import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/tools/tools.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/db_todo_repository.dart';

part 'create_task_form_cubit.freezed.dart';

const String _loggerPrefix = '[CUBIT - CREATE TASK FORM]';

class CreateTaskFormCubit extends Cubit<CreateTaskFormState> {
  bool _isNewTask = true;
  final String? taskToEditId;
  final TodoDbRepository todoRepository;

  // Assume that new task if not done
  // and has not deadline and title yet
  static final _defaultFormState = CreateTaskFormState(
    id: UuidGenerator.v4(),
    description: '',
    priority: TaskPriority.basic,
    isDone: false,
    createdAt: DateTime.now(),
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
      _isNewTask = false;

      final task = await todoRepository.getTodoById(taskId);
      if (task == null) {
        // TODO: Error handling for deep links
        // throw Exception('Task with id $taskId not found');
        return;
      }

      emit(
        CreateTaskFormState(
          id: task.id,
          description: task.description,
          priority: task.priority,
          deadline: task.finishUntil,
          isDone: task.isDone,
          createdAt: task.createdAt,
        ),
      );
    }
  }

  bool isSubmitAllowed() {
    return state.description.isNotEmpty;
  }

  TaskEntity toTaskEntity() {
    final commitTime = DateTime.now();

    return TaskEntity(
      id: state.id,
      description: state.description,
      isDone: state.isDone,
      priority: state.priority,
      finishUntil: state.deadline,
      changedAt: commitTime,
      createdAt: _isNewTask ? commitTime : state.createdAt,
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
    required String id,
    required DateTime createdAt,
    required bool isDone,
    required String description,
    required TaskPriority priority,
    DateTime? deadline,
  }) = _CreateTaskFormState;
}
