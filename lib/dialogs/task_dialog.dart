import 'package:flutter/material.dart';
import '../utils/validators.dart';

Future<void> showTaskDialog({
  required BuildContext context,
  required Function(Map<String, dynamic>) onSave,
  Map<String, dynamic>? existingTask,
}) async {
  final isEditing = existingTask != null;
  final task = existingTask != null
      ? Map<String, dynamic>.from(existingTask)
      : {
    'title': '',
    'category': '',
    'categoryColor': Colors.blueAccent,
    'done': false,
    'notify': false,
    'time': '',
    'date': '',
    'description': '',
  };

  final titleController = TextEditingController(text: task['title']);
  final categoryController = TextEditingController(text: task['category']);
  final dateController = TextEditingController(text: task['date']);
  final timeController = TextEditingController(text: task['time']);
  final descController = TextEditingController(text: task['description']);
  Color selectedColor = task['categoryColor'];
  bool notifyEnabled = task['notify'] ?? false;

  final formKey = GlobalKey<FormState>();

  await showGeneralDialog(
    context: context,
    barrierLabel: "TaskDialog",
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => const SizedBox(),
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.translate(
        offset: Offset(0, (1 - anim1.value) * 50),
        child: Opacity(
          opacity: anim1.value,
          child: StatefulBuilder(
            builder: (context, setInnerState) {
              return AlertDialog(
                title: Text(isEditing ? 'Редагувати завдання' : 'Нове завдання'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Назва'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Введіть назву' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: categoryController,
                          decoration: const InputDecoration(labelText: 'Категорія'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Введіть категорію' : null,
                        ),
                        const SizedBox(height: 8),
                        const Text('Колір категорії:'),
                        const SizedBox(height: 6),
                        Wrap(
                          children: [
                            for (var color in [
                              Colors.blueAccent,
                              Colors.purpleAccent,
                              Colors.greenAccent,
                              Colors.orangeAccent,
                              Colors.redAccent
                            ])
                              GestureDetector(
                                onTap: () => setInnerState(() {
                                  selectedColor = color;
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    boxShadow: selectedColor == color
                                        ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.6),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      )
                                    ]
                                        : [],
                                    border: Border.all(
                                      color: selectedColor == color ? Colors.black : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: dateController,
                          decoration: const InputDecoration(labelText: 'Дата (dd.MM.yyyy)'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Введіть дату';
                            if (!isValidDate(v)) return 'Неправильний формат дати';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: timeController,
                          decoration: const InputDecoration(labelText: 'Час (HH:mm)'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Введіть час';
                            if (!isValidTime(v)) return 'Неправильний формат часу';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: descController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: 'Детальний опис'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Нагадування'),
                            const SizedBox(width: 6),
                            Switch(
                              value: notifyEnabled,
                              onChanged: (val) {
                                setInnerState(() {
                                  notifyEnabled = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      final newTask = {
                        'title': titleController.text,
                        'category': categoryController.text,
                        'categoryColor': selectedColor,
                        'done': task['done'],
                        'notify': notifyEnabled,
                        'time': timeController.text,
                        'date': dateController.text,
                        'description': descController.text,
                      };
                      onSave(newTask);
                      Navigator.pop(context);
                    },
                    child: Text(isEditing ? 'Зберегти' : 'Додати'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
