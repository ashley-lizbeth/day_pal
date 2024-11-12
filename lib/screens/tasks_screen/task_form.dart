import 'package:flutter_todo/core/entities/task.dart';
import 'package:flutter_todo/database_context.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  final Task? baseTask;
  const TaskForm({super.key, this.baseTask});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  final controllers = FormControllers();

  @override
  void dispose() {
    super.dispose();
    controllers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = InheritedDatabase.of(context)!.db;

    void saveTask() {
      String id =
          widget.baseTask != null ? widget.baseTask!.id : db.tasks.newTask();

      Task taskToSave = Task(id);

      controllers.copyToTask(taskToSave);
      db.tasks.update(taskToSave);
    }

    if (widget.baseTask != null) {
      controllers.fromTask(widget.baseTask!);
    }

    String widgetTitle = widget.baseTask == null ? "New task" : "Edit task";
    String submitButtonMessage = widget.baseTask == null ? "Add" : "Update";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widgetTitle),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    widgetTitle,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ), */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title*",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: controllers.title,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: "Untitled"),
                        validator: (title) {
                          if (title == null || title.isEmpty) {
                            return "Title can't be empty";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description"),
                      TextFormField(
                        controller: controllers.description,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: ""),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveTask();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(submitButtonMessage))
              ],
            ),
          )),
    );
  }
}

class FormControllers {
  final title = TextEditingController();
  final description = TextEditingController();

  void fromTask(Task task) {
    title.text = task.title;
    description.text = task.description;
  }

  void copyToTask(Task task) {
    task.title = title.text;
    task.description = description.text;
  }

  void dispose() {
    title.dispose();
    description.dispose();
  }
}
