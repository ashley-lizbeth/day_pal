import 'dart:async';

import 'package:flutter_todo/core/entities/task.dart';

abstract class TaskRepository {
  Stream get repositoryUpdate;
  void open();
  void close();

  String newTask();
  Task? get(String id);
  List<Task> getAll();
  bool delete(String id);
  bool update(Task task);
}
}
