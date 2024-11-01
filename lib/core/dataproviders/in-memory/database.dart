import 'package:flutter_todo/core/dataproviders/in-memory/in_memory_task_repository.dart';
import 'package:flutter_todo/core/repositories/database_wrapper.dart';
import 'package:flutter_todo/core/repositories/task_repository.dart';

class InMemoryDatabase implements Database {
  @override
  late TaskRepository tasks = InMemoryTaskRepository();

  @override
  Future<void> open() async {
    tasks.open();
  }

  @override
  Future<void> close() async {
    tasks.close();
  }

  InMemoryDatabase();
}
