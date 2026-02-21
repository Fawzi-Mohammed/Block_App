import 'package:equatable/equatable.dart';

class TasksModel extends Equatable {
  final int id;
  final String title;
  final bool isCompleted;

  const TasksModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, title, isCompleted];
}
