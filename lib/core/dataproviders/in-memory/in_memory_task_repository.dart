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
  Future<void> open() async {
    _repoUpdateController = StreamController.broadcast();
  }

  @override
  Future<void> close() async {
    _tasks.clear();
    _repoUpdateController.close();
  }

  @override
  Future<String> newTask() async {
    final String id = cuid();

    var task = Task(id);
    _tasks[id] = task.getSelf();

    _repoUpdateController.add(TaskAction(TaskActionType.added, id));

    return id;
  }

  @override
  Future<Task?> get(String id) async {
    var task = _tasks[id];
    if (task == null) return null;
    return task.getSelf();
  }

  @override
  Future<List<Task>> getAll() async {
    return _tasks.entries.map((task) => task.value).toList();
  }

  @override
  Future<bool> delete(String id) async {
    return _tasks.remove(id) != null;
  }

  @override
  Future<bool> update(Task task) async {
    if (!_tasks.containsKey(task.id)) {
      return false;
    }

    _tasks[task.id] = task;

    _repoUpdateController.add(TaskAction(TaskActionType.updated, task.id));
    return true;
  }
}
