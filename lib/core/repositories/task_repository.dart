import 'dart:async';

import 'package:day_pal/core/entities/task.dart';

abstract class TaskRepository {
  Stream<TaskAction> get repositoryUpdate;
  void open();
  void close();

  String newTask();
  Task? get(String id);
  List<Task> getAll();
  bool delete(String id);
  bool update(Task task);
}

enum TaskActionType { added, updated, deleted }

class TaskAction {
  TaskActionType type;
  String id;

  TaskAction(this.type, this.id);
}
