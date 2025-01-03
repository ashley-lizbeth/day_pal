import 'package:day_pal/core/entities/task.dart';
import 'package:day_pal/core/utils/convert_datetime_to_text.dart';
import 'package:day_pal/database_context.dart';
import 'package:day_pal/screens/tasks_screen/task_form/deadline_form.dart';
import 'package:day_pal/screens/tasks_screen/task_form/description_form.dart';
import 'package:day_pal/screens/tasks_screen/task_form/priority_form.dart';
import 'package:day_pal/screens/tasks_screen/task_form/status_form.dart';
import 'package:day_pal/screens/tasks_screen/task_form/title_form.dart';
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
  void initState() {
    if (widget.baseTask != null) {
      controllers.fromTask(widget.baseTask!);
    }

    super.initState();
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = InheritedDatabase.of(context).db;

    final List<Widget> formFields = [
      TitleForm(controller: controllers.title),
      DescriptionForm(controller: controllers.description),
      DeadlineForm(controller: controllers.deadline),
      PriorityForm(
        controller: controllers.priority,
      ),
      StatusForm(
        controller: controllers.status,
      ),
    ];

    Future<void> saveTask() async {
      String id = widget.baseTask != null
          ? widget.baseTask!.id
          : await db.tasks.newTask();

      Task taskToSave = Task(id);

      controllers.copyToTask(taskToSave);
      await db.tasks.update(taskToSave);
    }

    String widgetTitle = widget.baseTask == null ? "New task" : "Edit task";
    String submitButtonMessage = widget.baseTask == null ? "Add" : "Update";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(widgetTitle),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: formFields
                        .map((field) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: field,
                            ))
                        .toList(),
                  ),
                  Builder(builder: (_) {
                    if (widget.baseTask == null) return SizedBox();
                    return Text(
                      "Created: ${displayDateTimeWithContext(context, widget.baseTask!.createdAt)}",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            )),
                        MaterialButton(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await saveTask();
                                if (context.mounted) Navigator.pop(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Text(
                                submitButtonMessage,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class FormControllers {
  final title = TextEditingController();
  final description = TextEditingController();
  final deadline = DeadlineController();
  final priority = PriorityController();
  final status = StatusController();

  void fromTask(Task task) {
    title.text = task.title;
    description.text = task.description;
    if (task.deadline != null) {
      deadline.setEnabled(true);
      deadline.setDate(task.deadline!);
    }
    priority.setValue(task.priority());
    status.setValue(task.status());
  }

  void copyToTask(Task task) {
    task.title = title.text;
    task.description = description.text;
    task.deadline = deadline.enabled ? deadline.date : null;
    task.priorityValue = priority.value.importance;
    task.statusKey = status.value.key;
  }

  void dispose() {
    title.dispose();
    description.dispose();
    deadline.dispose();
    priority.dispose();
    status.dispose();
  }
}
