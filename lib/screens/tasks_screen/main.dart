import 'dart:async';
import 'package:flutter/material.dart';

import 'package:day_pal/core/repositories/task_repository.dart';
import 'package:day_pal/core/entities/task.dart';
import 'package:day_pal/database_context.dart';
import 'package:day_pal/screens/tasks_screen/task_form/main.dart';
import 'package:day_pal/screens/tasks_screen/task_item.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];

  StreamSubscription<TaskAction>? dbSubscription;

  @override
  void dispose() {
    dbSubscription?.cancel();
    super.dispose();
  }

  void addTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  void removeTask(String id) {
    setState(() {
      tasks.removeAt(tasks.indexWhere((task) => task.id == id));
    });
  }

  void updateTask(Task updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = InheritedDatabase.of(context).db;
    db.tasks.getAll().then((taskList) => setState(() {
          tasks = taskList;
          tasks.sort();
        }));

    dbSubscription = db.tasks.repositoryUpdate.listen((event) async {
      if (event.type == TaskActionType.deleted) {
        removeTask(event.id);
        return;
      }

      var task = await db.tasks.get(event.id);

      if (task != null) {
        if (event.type == TaskActionType.added) {
          addTask(task);
        } else {
          updateTask(task);
        }
      }
    });

    return Scaffold(
      body: Builder(builder: (context) {
        if (tasks.isEmpty) {
          return Center(
            child: Text("No tasks found"),
          );
        }

        return ListView(
          children: tasks
              .map((task) => Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete_forever,
                            size: 40, color: Colors.white),
                        SizedBox(
                          width: 40,
                        )
                      ],
                    ),
                  ),
                  onDismissed: (_) async {
                    removeTask(task.id);
                    await db.tasks.delete(task.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Task dismissed")));
                    }
                  },
                  child: TaskItem(task: task)))
              .toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TaskForm()));
        },
      ),
    );
  }
}
