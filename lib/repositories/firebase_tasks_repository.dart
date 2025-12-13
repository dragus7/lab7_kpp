import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';
import 'tasks_repository.dart';

class FirebaseTasksRepository implements TasksRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseTasksRepository(this._firestore, this._auth);

  CollectionReference get _tasks =>
      _firestore.collection('Tasks');

  @override
  Stream<List<Task>> getUserTasks() {
    final user = _auth.currentUser!;
    return _tasks
        .where('task_owner', isEqualTo: user.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return Task.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList());
  }

  @override
  Future<void> addTask(Task task) async {
    await _tasks.add(task.toFirestore());
  }

  @override
  Future<void> updateTask(Task task) async {
    await _tasks.doc(task.id).update(task.toFirestore());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }
}
