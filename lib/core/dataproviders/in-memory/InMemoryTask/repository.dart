import 'dart:async';

import 'package:cuid2/cuid2.dart';
import 'package:flutter_todo/core/entities/task.dart';
import 'package:flutter_todo/core/repositories/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final _tasks = <String, Task>{};

  late StreamController _repoUpdateController;

  @override
  Stream get repositoryUpdate => _repoUpdateController.stream;

  @override
  void open() {
    _repoUpdateController = StreamController.broadcast();
  }

  @override
  void close() {
    _tasks.clear();
    _repoUpdateController.close();
  }

  @override
  Task newTask(String title) {
    final String id = cuid();

    var task = Task(id, title);

    _repoUpdateController.add(task.id);

    return task;
  }

  @override
  Task? get(String id) {
    return _tasks[id];
  }

  @override
  List<Task> getAll() {
    return _tasks.entries.map((task) => task.value).toList();
  }

  @override
  bool delete(String id) {
    return _tasks.remove(id) != null;
  }

  @override
  bool update(String id, Task task) {
    if (!_tasks.containsKey(id)) {
      return false;
    }

    _tasks[id] = task;
    return true;
  }
}
