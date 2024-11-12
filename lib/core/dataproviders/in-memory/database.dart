import 'package:day_pal/core/dataproviders/in-memory/in_memory_task_repository.dart';
import 'package:day_pal/core/repositories/database_wrapper.dart';
import 'package:day_pal/core/repositories/task_repository.dart';

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
