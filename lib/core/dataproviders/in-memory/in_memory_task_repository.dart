import 'dart:async';

import 'package:cuid2/cuid2.dart';
import 'package:day_pal/core/entities/task.dart';
import 'package:day_pal/core/repositories/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final _tasks = <String, Task>{};

  late StreamController<TaskAction> _repoUpdateController;

  @override
  Stream<TaskAction> get repositoryUpdate => _repoUpdateController.stream;

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
  String newTask() {
    final String id = cuid();

    var task = Task(id);
    _tasks[id] = task.getSelf();

    _repoUpdateController.add(TaskAction(TaskActionType.added, id));

    return id;
  }

  @override
  Task? get(String id) {
    var task = _tasks[id];
    if (task == null) return null;
    return task.getSelf();
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
  bool update(Task task) {
    if (!_tasks.containsKey(task.id)) {
      return false;
    }

    _tasks[task.id] = task;

    _repoUpdateController.add(TaskAction(TaskActionType.updated, task.id));
    return true;
  }
}
