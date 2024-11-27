import 'dart:async';

import 'package:day_pal/core/entities/task.dart';

abstract class TaskRepository {
  Stream<TaskAction> get repositoryUpdate;
  Future<void> open();
  Future<void> close();

  Future<String> newTask();
  Future<Task?> get(String id);
  Future<List<Task>> getAll();
  Future<bool> delete(String id);
  Future<bool> update(Task task);
}

enum TaskActionType { added, updated, deleted }

class TaskAction {
  TaskActionType type;
  String id;

  TaskAction(this.type, this.id);
}
