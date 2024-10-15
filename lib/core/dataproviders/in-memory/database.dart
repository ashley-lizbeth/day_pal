import 'package:flutter_todo/core/dataproviders/in-memory/InMemoryTask/repository.dart';
import 'package:flutter_todo/core/repositories/database_wrapper.dart';
import 'package:flutter_todo/core/repositories/task_repository.dart';

class InMemoryDatabase implements Database {
  @override
  TaskRepository? tasks;

  @override
  Future<void> open() async {
    tasks = InMemoryTaskRepository();
  }

  @override
  Future<void> close() async {
    tasks = null;
  }

  InMemoryDatabase();
}
