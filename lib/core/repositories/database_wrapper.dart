import 'package:day_pal/core/repositories/task_repository.dart';

abstract class Database {
  late TaskRepository tasks;

  Future<void> open();
  Future<void> close();

  Database();
}
