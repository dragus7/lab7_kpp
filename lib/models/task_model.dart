import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String taskName;
  final String taskDescription;
  final String taskCategory;
  final String taskColor;
  final DateTime taskDeadline;
  final bool taskNotification;
  final String taskOwner;

  const Task({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.taskCategory,
    required this.taskColor,
    required this.taskDeadline,
    required this.taskNotification,
    required this.taskOwner,
  });

  factory Task.fromFirestore(
      Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      taskName: data['task_name'] ?? '',
      taskDescription: data['task_description'] ?? '',
      taskCategory: data['task_category'] ?? '',
      taskColor: data['task_color'] ?? '',
      taskDeadline:
      (data['task_deadline'] as Timestamp).toDate(),
      taskNotification: data['task_notification'] ?? false,
      taskOwner: data['task_owner'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'task_name': taskName,
      'task_description': taskDescription,
      'task_category': taskCategory,
      'task_color': taskColor,
      'task_deadline': Timestamp.fromDate(taskDeadline),
      'task_notification': taskNotification,
      'task_owner': taskOwner,
    };
  }
}
