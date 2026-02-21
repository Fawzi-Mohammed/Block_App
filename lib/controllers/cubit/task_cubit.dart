import 'package:block_app/models/tasks_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  void addTask({required String title}) {
    final TasksModel task = TasksModel(
      id: const Uuid().v4(),
      title: title,
      isCompleted: false,
    );
    emit(UpdateTask([...state.tasks, task]));
  }

  void removeTask(String id) {
    final List<TasksModel> newList = state.tasks
        .where((task) => task.id != id)
        .toList();
    emit(UpdateTask(newList));
  }

  void toggleTask(String id) {
    final List<TasksModel> newList = state.tasks.map((task) {
      return task.id == id
          ? task.copyWith(isCompleted: !task.isCompleted)
          : task;
    }).toList();
    emit(UpdateTask(newList));
  }
}
