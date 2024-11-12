import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/core/dataproviders/in-memory/database.dart';
import 'package:flutter_todo/core/entities/priority.dart';
import 'package:flutter_todo/core/entities/status.dart';

import 'package:flutter_todo/core/entities/task.dart';
import 'package:flutter_todo/core/repositories/database_wrapper.dart';

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
    late Database db = InMemoryDatabase();

    setUp(() {
      db.open();
    });

    tearDown(() {
      db.close();
    });

    test("Database is open", () {
      // Expand when adding new repositories
    });

    test("Insert task into database", () {
      var newTask = db.tasks.newTask("A new task");
      expect(newTask.title, "A new task");
    });

    test("Insert two tasks with different ids", () {
      var task1 = db.tasks.newTask("Task 1");
      var task2 = db.tasks.newTask("Task 2");

      expect(task1.id != task2.id, true);
    });

    test("Retrieve task from database", () {
      var createdTask = db.tasks.newTask("Task 1");

      var retrievedTask = db.tasks.get(createdTask.id);
      expect(retrievedTask, createdTask);
    });

    test("Update task in database", () {
      var originalTask = db.tasks.newTask("Task 1");

      originalTask.title = "Updated title";
      originalTask.priorityValue = Priority.low;

      var taskBeforeSave = db.tasks.get(originalTask.id);
      assert(taskBeforeSave != originalTask);

      var didSave = originalTask.save();
      assert(didSave);

      var retrievedTask = db.tasks.get(originalTask.id);
      expect(originalTask, retrievedTask);
    });

    test("Delete created task", () {
      var task = db.tasks.newTask("Task to delete");
      var didDelete = db.tasks.delete(task.id);
      assert(didDelete);

      var retrievedTask = db.tasks.get(task.id);
      expect(retrievedTask, null);

      task = db.tasks.newTask("Another task to delete");
      didDelete = task.delete();
      assert(didDelete);

      retrievedTask = db.tasks.get(task.id);
      expect(retrievedTask, null);
    });

    test("Get, update and delete nonexistant id", () {
      var retrievedTask = db.tasks.get("Bad id");
      expect(retrievedTask, null);

      expect(db.tasks.update("Bad id", Task("1", "1")), false);
      expect(db.tasks.delete("Bad id"), false);
    });

    test("Get all tasks", () {
      db.tasks.newTask("Task 1");
      db.tasks.newTask("Task 2");

      List<Task> allTasks = db.tasks.getAll();

      expect(allTasks.length, 2);
      expect(allTasks[0].title, "Task 1");
      expect(allTasks[1].title, "Task 2");
    });
  });
}
