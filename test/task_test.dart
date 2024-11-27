import 'package:flutter_test/flutter_test.dart';

import 'package:day_pal/core/dataproviders/sqlite/sqlite_database.dart';
import 'package:day_pal/core/dataproviders/in-memory/in_memory_database.dart';

import 'package:day_pal/core/entities/priority.dart';
import 'package:day_pal/core/entities/status.dart';

import 'package:day_pal/core/entities/task.dart';
import 'package:day_pal/core/repositories/database_wrapper.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
      final task = Task("A sample task");
      task.createdAt = DateTime.utc(2024, 12, 31);
      task.deadline = DateTime.utc(2020, 01, 01);

      expect(task.deadline, DateTime.utc(2020, 01, 01));
      expect(task.hasExpired(), true);
    });

    test('Create task with no deadline', () {
      final task = Task("Another task");

      expect(task.deadline, null);
      expect(task.hasExpired(), null);
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

  group("Task database testing", () {
    late DatabaseWrapper db;

    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      db = SqliteDatabase();
      await db.open();
    });

    tearDown(() async {
      await db.close();
    });

    test("Insert task into database", () async {
      var newTaskID = await db.tasks.newTask();
      var createdTask = await db.tasks.get(newTaskID);
      assert(createdTask != null);
    });

    test("Insert two tasks with different ids", () async {
      var id1 = await db.tasks.newTask();
      var id2 = await db.tasks.newTask();

      assert(id1 != id2);
    });

    test("Retrieve task from database", () async {
      var id = await db.tasks.newTask();

      var retrievedTask = await db.tasks.get(id);

      assert(retrievedTask != null);
      expect(retrievedTask!.id, id);
    });

    test("Update task in database", () async {
      var taskID = await db.tasks.newTask();
      Task? originalTask = await db.tasks.get(taskID);

      assert(originalTask is Task);

      originalTask!.title = "Updated title";
      originalTask.priorityValue = Priority.low;

      var taskBeforeSave = await db.tasks.get(taskID);
      assert(taskBeforeSave != originalTask);

      var didSave = await db.tasks.update(originalTask);
      assert(didSave);

      var retrievedTask = await db.tasks.get(originalTask.id);
      expect(originalTask, retrievedTask);
    });

    test("Delete created task", () async {
      var id = await db.tasks.newTask();
      var didDelete = await db.tasks.delete(id);
      assert(didDelete);

      var retrievedTask = await db.tasks.get(id);
      expect(retrievedTask, null);
    });

    test("Get, update and delete nonexistant id", () async {
      var retrievedTask = await db.tasks.get("Bad id");
      expect(retrievedTask, null);

      expect(await db.tasks.update(Task("Bad id")), false);
      expect(await db.tasks.delete("Bad id"), false);
    });

    test("Get all tasks", () async {
      String id1 = await db.tasks.newTask();
      String id2 = await db.tasks.newTask();

      List<Task> allTasks = await db.tasks.getAll();

      expect(allTasks.length, 2);
      expect(allTasks[0].id, id1);
      expect(allTasks[1].id, id2);
    });
  });
}
