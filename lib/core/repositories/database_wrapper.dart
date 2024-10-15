import 'package:flutter_todo/core/repositories/task_repository.dart';

abstract class Database {
  TaskRepository? tasks;

  Future<void> open();
  Future<void> close();

  Database();
}
