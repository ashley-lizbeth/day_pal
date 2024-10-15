import 'package:flutter_todo/core/entities/task.dart';

abstract class TaskRepository {
  Task newTask(String title);
  Task? get(String id);
  bool delete(String id);
  bool update(String id, Task task);
}
