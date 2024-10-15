import 'package:cuid2/cuid2.dart';
import 'package:flutter_todo/core/dataproviders/in-memory/InMemoryTask/entity.dart';
import 'package:flutter_todo/core/entities/task.dart';
import 'package:flutter_todo/core/repositories/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final _tasks = <String, Task>{};

  @override
  Task newTask(String title) {
    final String id = cuid();

    var task = InMemoryTask(id, title, this);
    _tasks[task.id] = task.getSelf();

    return task;
  }

  @override
  Task? get(String id) {
    var task = _tasks[id];
    if (task == null) return null;
    return InMemoryTask.from(task, task.id, task.title, this);
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
