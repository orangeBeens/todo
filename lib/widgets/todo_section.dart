import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_item.dart';

class TodoSection extends StatelessWidget {
  final String title;
  final List<Todo> todos;
  final Function(String) onToggle;
  final Function(String) onDelete;

  const TodoSection({
    super.key,
    required this.title,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoItem(
              todo: todo,
              onToggle: onToggle,
              onDelete: onDelete,
            );
          },
        ),
      ],
    );
  }
}