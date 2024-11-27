import 'package:day_pal/core/repositories/task_repository.dart';

abstract class DatabaseWrapper {
  late TaskRepository tasks;

  Future<void> open();
  Future<void> close();

  DatabaseWrapper();
}
