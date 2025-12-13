import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repositories/tasks_repository.dart';

class TaskState extends ChangeNotifier {
  final TasksRepository _repository;
  StreamSubscription<List<Task>>? _subscription;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaskState(this._repository);

  void loadTasks() {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.getUserTasks().listen((tasks) {
      _tasks = tasks;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
