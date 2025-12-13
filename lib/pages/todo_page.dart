import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialogs/task_dialog.dart';
import 'profile_page.dart';
import '../task_state.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  void _editOrAddTask(BuildContext context, {Map<String, dynamic>? existingTask}) {
    showTaskDialog(
      context: context,
      existingTask: existingTask,
      onSave: (newTask) {
        final taskState = context.read<TaskState>();
        taskState.editOrAddTask(newTask, existingTask: existingTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = context.watch<TaskState>();

    Widget bodyContent;

    // 🔹 Перевіряємо статус
    switch (taskState.status) {
      case TaskStatus.loading:
        bodyContent = const Center(child: CircularProgressIndicator());
        break;

      case TaskStatus.error:
        bodyContent = Center(
          child: Text(
            'Помилка: ${taskState.errorMessage}',
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        );
        break;

      case TaskStatus.success:
        bodyContent = ListView.builder(
          itemCount: taskState.tasks.length,
          itemBuilder: (context, index) {
            final task = taskState.tasks[index];
            return GestureDetector(
              onTap: () => _editOrAddTask(context, existingTask: task),
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
                  leading: Checkbox(
                    shape: const CircleBorder(),
                    value: task['done'],
                    onChanged: (_) => taskState.toggleDone(task),
                  ),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      decoration: task['done']
                          ? TextDecoration.lineThrough
                          : null,
                      color: task['done'] ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: task['categoryColor'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task['category'],
                          style: TextStyle(
                            color: task['categoryColor'].withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${task['time']}  ${task['date']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (task['notify'])
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.black54,
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black54,
                        ),
                        onPressed: () => taskState.deleteTask(task),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        break;
    }

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
            Text(
              '🕗 ${taskState.activeCount} активних     ✅ ${taskState.doneCount} виконано',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var tab in ['Всі', 'Активні', 'Виконані'])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () => taskState.setFilter(tab),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          taskState.filter == tab ? Colors.black : Colors.white,
                          foregroundColor:
                          taskState.filter == tab ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(tab),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: bodyContent),
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
