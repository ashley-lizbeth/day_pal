import 'package:day_pal/core/utils/convert_datetime_to_text.dart';
import 'package:day_pal/database_context.dart';
import 'package:day_pal/screens/tasks_screen/task_form/main.dart';
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
    final db = InheritedDatabase.of(context).db;

    Status status = widget.task.status();
    Priority priority = widget.task.priority();

    String deadlineText = widget.task.deadline != null
        ? convertDateTimeToText(widget.task.deadline!)
        : "No deadline";
    Color? deadlineColor = Colors.black;

    Color? defaultColor = Colors.black;
    TextDecoration? defaultDecoration;

    if (widget.task.statusKey != Status.completed) {
      if (widget.task.deadline != null) {
        if (widget.task.expiresToday()) deadlineColor = Colors.orange[800];
        if (widget.task.hasExpired()) deadlineColor = Colors.red[800];
      }
    }

    if (widget.task.statusKey == Status.completed) {
      defaultColor = Colors.grey;
      deadlineColor = defaultColor;
      defaultDecoration = TextDecoration.lineThrough;
    }

    return DefaultTextStyle(
      style: TextStyle(color: defaultColor, decoration: defaultDecoration),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(builder: (_) {
                          if (widget.task.deadline == null) return SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(
                                    Icons.calendar_month,
                                  ),
                                ),
                                Text(
                                  deadlineText,
                                  style: TextStyle(color: deadlineColor),
                                )
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (status.key == Status.blocked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Task is blocked")));
                                return;
                              }

                              widget.task.statusKey =
                                  status.key == Status.completed
                                      ? Status.doing
                                      : Status.completed;

                              db.tasks.update(widget.task);
                            },
                            child: status.icon),
                        Padding(
                          padding: EdgeInsets.symmetric(),
                          child: priority.icon,
                        ),
                        Text(
                          widget.task.title,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Builder(builder: (_) {
                      if (widget.task.description == "") return SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(widget.task.description),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
