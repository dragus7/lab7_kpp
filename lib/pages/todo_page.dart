import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/task_dialog.dart';
import '../models/task_model.dart';
import '../task_state.dart';
import 'profile_page.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  Color _parseColor(String colorValue) {
    final parsed = int.tryParse(colorValue);
    if (parsed != null) return Color(parsed);
    return Colors.blueAccent;
  }

  DateTime _parseDeadline(String date, String time) {
    try {
      final dateParts = date.split('.');
      final timeParts = time.split(':');

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return DateTime.now();
    }
  }

  void _editOrAddTask(BuildContext context, {Task? existingTask}) {
    showTaskDialog(
      context: context,
      existingTask: existingTask == null
          ? null
          : {
              'title': existingTask.taskName,
              'category': existingTask.taskCategory,
              'categoryColor': _parseColor(existingTask.taskColor),
              'done': false,
              'notify': existingTask.taskNotification,
              'time': '${existingTask.taskDeadline.hour.toString().padLeft(2, '0')}:${existingTask.taskDeadline.minute.toString().padLeft(2, '0')}',
              'date': '${existingTask.taskDeadline.day.toString().padLeft(2, '0')}.${existingTask.taskDeadline.month.toString().padLeft(2, '0')}.${existingTask.taskDeadline.year}',
              'description': existingTask.taskDescription,
            },
      onSave: (newTask) async {
        final taskState = context.read<TaskState>();
        final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

        final updatedTask = Task(
          id: existingTask?.id ?? '',
          taskName: newTask['title'],
          taskDescription: newTask['description'] ?? '',
          taskCategory: newTask['category'],
          taskColor: (newTask['categoryColor'] as Color).value.toString(),
          taskDeadline: _parseDeadline(newTask['date'], newTask['time']),
          taskNotification: newTask['notify'] ?? false,
          taskOwner: existingTask?.taskOwner ?? userEmail,
        );

        if (existingTask == null) {
          await taskState.addTask(updatedTask);
        } else {
          await taskState.updateTask(updatedTask);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = context.watch<TaskState>();
    final tasks = taskState.tasks;
    final isLoading = taskState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мої завдання',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('lib/assets/images/unnamed.jpg'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tasks.isEmpty
                      ? const Center(child: Text('Ще немає завдань'))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final categoryColor = _parseColor(task.taskColor);
                            final deadline = task.taskDeadline;

                            return GestureDetector(
                              onTap: () => _editOrAddTask(
                                context,
                                existingTask: task,
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    task.taskName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        task.taskDescription,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: categoryColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              task.taskCategory,
                                              style: TextStyle(
                                                color: categoryColor.withOpacity(0.9),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.access_time, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}  ${deadline.day.toString().padLeft(2, '0')}.${deadline.month.toString().padLeft(2, '0')}.${deadline.year}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (task.taskNotification)
                                        const Icon(
                                          Icons.notifications_active_outlined,
                                          color: Colors.black54,
                                        ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.black54,
                                        ),
                                        onPressed: () => taskState.deleteTask(task.id),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _editOrAddTask(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
