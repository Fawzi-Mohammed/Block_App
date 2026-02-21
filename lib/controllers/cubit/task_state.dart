part of 'task_cubit.dart';

sealed class TaskState extends Equatable {
  const TaskState(this.tasks);
  final List<TasksModel> tasks;
  @override
  List<Object> get props => [tasks];
}

final class TaskInitial extends TaskState {
  TaskInitial():super([]);
}

final class UpdateTask extends TaskState{
 const UpdateTask(super.tasks);
  
}