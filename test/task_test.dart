import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/core/dataproviders/in-memory/database.dart';
import 'package:flutter_todo/core/entities/status.dart';

import 'package:flutter_todo/core/entities/task.dart';
import 'package:flutter_todo/core/repositories/database_wrapper.dart';

void main() {
  group("Task entity testing", () {
    test('Create new task', () {
      final task = Task("Some id", "A sample task");

      expect(task.id, "Some id");
      expect(task.title, "A sample task");
      expect(task.priority, 3);
      expect(task.status, Status.doing);
      expect(task.reasonForStatus, "");
      expect(task.deadline, null);
    });

    test('Compare task with expired deadline', () {
      final task = Task("0", "A sample task");
      task.createdAt = DateTime.utc(2024, 12, 31);
      task.deadline = DateTime.utc(2020, 01, 01);

      expect(task.deadline, DateTime.utc(2020, 01, 01));
      expect(task.hasExpired(), true);
    });

    test('Create task with no deadline', () {
      final task = Task("0", "Another task");

      expect(task.deadline, null);
      expect(task.hasExpired(), null);
    });

    test('Create task with priority', () {
      final topTask = Task("1", "Important task");
      topTask.priority = 1;

      final lowTask = Task("2", "Unimportant task");
      lowTask.priority = 5;

      expect(topTask.isHigherPriority(lowTask), true);
    });

    test('Mark task as completed', () {
      final task = Task("0", "New task");
      expect(task.status, Status.doing);

      task.status = Status.completed;
      expect(task.status, Status.completed);
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
      expect(db.tasks != null, true);
    });

    test("Insert task into database", () {
      var newTask = db.tasks!.newTask("A new task");
      expect(newTask.title, "A new task");
    });

    test("Insert two tasks with different ids", () {
      var task1 = db.tasks!.newTask("Task 1");
      var task2 = db.tasks!.newTask("Task 2");

      expect(task1.id != task2.id, true);
    });

    test("Retrieve task from database", () {
      var createdTask = db.tasks!.newTask("Task 1");

      var retrievedTask = db.tasks!.get(createdTask.id);
      expect(retrievedTask, createdTask);
    });

    test("Update task in database", () {
      var originalTask = db.tasks!.newTask("Task 1");

      originalTask.title = "Updated title";
      originalTask.priority = 5;

      var taskBeforeSave = db.tasks!.get(originalTask.id);
      assert(taskBeforeSave != originalTask);

      var didSave = originalTask.save();
      assert(didSave);

      var retrievedTask = db.tasks!.get(originalTask.id);
      expect(originalTask, retrievedTask);
    });

    test("Delete created task", () {
      var task = db.tasks!.newTask("Task to delete");
      var didDelete = db.tasks!.delete(task.id);
      assert(didDelete);

      var retrievedTask = db.tasks!.get(task.id);
      expect(retrievedTask, null);

      task = db.tasks!.newTask("Another task to delete");
      didDelete = task.delete();
      assert(didDelete);

      retrievedTask = db.tasks!.get(task.id);
      expect(retrievedTask, null);
    });

    test("Get, update and delete nonexistant id", () {
      var retrievedTask = db.tasks!.get("Bad id");
      expect(retrievedTask, null);

      expect(db.tasks!.update("Bad id", Task("1", "1")), false);
      expect(db.tasks!.delete("Bad id"), false);
    });
  });
}
