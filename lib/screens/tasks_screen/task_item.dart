import 'package:day_pal/database_context.dart';
import 'package:day_pal/screens/tasks_screen/task_form.dart';
import 'package:flutter/material.dart';
import 'package:day_pal/core/entities/priority.dart';
import 'package:day_pal/core/entities/status.dart';
import 'package:day_pal/core/entities/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final db = InheritedDatabase.of(context)!.db;

    Status status = widget.task.status();
    Priority priority = widget.task.priority();
    String? deadline = widget.task.deadline?.toString();

    return Column(
      children: [
        Row(
          children: [
            Flexible(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      if (status.key == Status.blocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Task is blocked")));
                        return;
                      }

                      widget.task.statusKey = status.key == Status.completed
                          ? Status.doing
                          : Status.completed;

                      db.tasks.update(widget.task);
                    },
                    child: Icon(status.icon))),
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TaskForm(
                                baseTask: widget.task,
                              )));
                },
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      if (deadline != null) {
                        return Row(children: [
                          Icon(Icons.calendar_month),
                          Text(deadline)
                        ]);
                      }

                      return Text("No deadline");
                    }),
                    Row(
                      children: [priority.icon, Text(widget.task.title)],
                    ),
                    Text(widget.task.description),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
