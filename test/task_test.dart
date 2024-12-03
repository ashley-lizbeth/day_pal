import 'package:flutter_test/flutter_test.dart';

import 'package:day_pal/core/dataproviders/sqlite/sqlite_database.dart';
import 'package:day_pal/core/dataproviders/in-memory/in_memory_database.dart';

import 'package:day_pal/core/entities/priority.dart';
import 'package:day_pal/core/entities/status.dart';

import 'package:day_pal/core/entities/task.dart';
import 'package:day_pal/core/repositories/database_wrapper.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_test.dart';

void main() {
  group("Task entity testing", () {
    test('Create new task', () {
      final task = Task("A sample task");

      expect(task.id, "A sample task");
      expect(task.title, "");
      expect(task.priorityValue, Priority.neutral);
      expect(task.statusKey, Status.doing);
      expect(task.deadline, null);
    });

    test('Create task with expired deadline', () {
      final expiredTask = Task("Expired task");
      final aMinuteAgo = DateTime.now().subtract(Duration(minutes: 1));
      expiredTask.deadline = aMinuteAgo;

      final goodTask = Task("Not expired");
      goodTask.deadline = DateTime.now().add(Duration(hours: 1));

      expect(expiredTask.hasExpired(), true);
      expect(goodTask.hasExpired(), false);
    });

    test('Create task with no deadline', () {
      final task = Task("Another task");

      expect(task.deadline, null);
      expect(task.hasExpired(), false);
      expect(task.expiresToday(), false);
    });

    });

    test('Compare tasks with differing priority', () {
      final topTask = Task("Important task");
      topTask.priorityValue = Priority.highest;

      final lowTask = Task("Unimportant task");
      lowTask.priorityValue = Priority.lowest;

      expect(topTask.isHigherPriority(lowTask), true);
    });

    test('Mark task as completed', () {
      final task = Task("0");
      expect(task.statusKey, Status.doing);

      task.statusKey = Status.completed;
      expect(task.statusKey, Status.completed);
    });
  });

  group("InMemoryTask database testing", () {
    DatabaseWrapper inMemoryDB = InMemoryDatabase();

    coreTaskDatabaseTests(inMemoryDB);
  });

  group("SQLiteTask database testing", () {
    DatabaseWrapper sqliteDB = SqliteDatabase();

    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    coreTaskDatabaseTests(sqliteDB);
  });
}
