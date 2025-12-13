import '../models/task_model.dart';

abstract class TasksRepository {
  Stream<List<Task>> getUserTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
