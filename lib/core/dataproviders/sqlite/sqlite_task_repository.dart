import 'dart:async';

import 'package:cuid2/cuid2.dart';
import 'package:day_pal/core/entities/task.dart';
import 'package:day_pal/core/repositories/task_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteTaskRepository implements TaskRepository {
  final Database _provider;

  late StreamController<TaskAction> _repoUpdateController;

  SqliteTaskRepository(this._provider);

  @override
  Future<void> close() async {
    _repoUpdateController.close();
  }

  @override
  Future<bool> delete(String id) async {
    return await _provider.delete(SqliteTask.tableName,
            where: '${SqliteTask.columnID} = ?', whereArgs: [id]) !=
        0;
  }

  @override
  Future<Task?> get(String id) async {
    List<Map<String, Object?>> results = await _provider.query(
        SqliteTask.tableName,
        where: '${SqliteTask.columnID} = ?',
        whereArgs: [id]);

    if (results.isEmpty) return null;
    return SqliteTask.fromMap(results.first).getSelf();
  }

  @override
  Future<List<Task>> getAll() async {
    List<Map<String, Object?>> results =
        await _provider.query(SqliteTask.tableName);

    return results.map((map) => SqliteTask.fromMap(map).getSelf()).toList();
  }

  @override
  Future<String> newTask() async {
    final String id = cuid();
    var task = SqliteTask(id);

    await _provider.insert(SqliteTask.tableName, task.toMap());

    return id;
  }

  @override
  Future<void> open() async {
    _repoUpdateController = StreamController.broadcast();
  }

  @override
  Stream<TaskAction> get repositoryUpdate => _repoUpdateController.stream;

  @override
  Future<bool> update(Task task) async {
    var tempTask = SqliteTask(task.id);
    tempTask.copyFrom(task);

    var updateMap = tempTask.toMap();
    updateMap.remove(SqliteTask.columnID);
    updateMap.remove(SqliteTask.columnCreatedAt);

    return await _provider.update(SqliteTask.tableName, updateMap,
            where: '${SqliteTask.columnID} = ?', whereArgs: [task.id]) !=
        0;
  }
}

class SqliteTask extends Task {
  static const String tableName = "tasks",
      columnID = "_id",
      columnTitle = "title",
      columnDescription = "description",
      columnPriority = "priorityValue",
      columnStatus = "statusKey",
      columnDeadline = "deadline",
      columnCreatedAt = "createdAt";

  SqliteTask(super.id);

  static SqliteTask fromMap(Map<String, Object?> map) {
    var id = map[columnID] as String;
    var task = SqliteTask(id);

    task.title = map[columnTitle] as String;
    task.description = map[columnDescription] as String;
    task.priorityValue = map[columnPriority] as int;
    task.statusKey = map[columnStatus] as String;

    try {
      task.deadline = DateTime.parse(map[columnDeadline] as String);
    } catch (_) {
      task.deadline = null;
    }

    try {
      task.createdAt = DateTime.parse(map[columnCreatedAt] as String);
    } catch (_) {}

    return task;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      columnID: id,
      columnTitle: title,
      columnDescription: description,
      columnPriority: priorityValue,
      columnStatus: statusKey,
      columnDeadline: deadline.toString(),
      columnCreatedAt: createdAt.toString()
    };
  }
}
