import 'dart:io' as io;

import 'package:day_pal/core/dataproviders/sqlite/sqlite_task_repository.dart';
import 'package:day_pal/core/repositories/database_wrapper.dart';
import 'package:day_pal/core/repositories/task_repository.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteDatabase implements DatabaseWrapper {
  late Database _db;

  @override
  late TaskRepository tasks = SqliteTaskRepository(_db);

  @override
  Future<void> open() async {
    String dbPath;

    if (io.Platform.environment.containsKey("FLUTTER_TEST")) {
      dbPath = inMemoryDatabasePath;
    } else {
      final io.Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      dbPath = path.join(appDocumentsDir.path, "databases", "daypal.sqlite");
    }

    _db = await databaseFactoryFfi.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE ${SqliteTask.tableName} (
                ${SqliteTask.columnID} text primary key not null,
                ${SqliteTask.columnTitle} text not null,
                ${SqliteTask.columnDescription} text,
                ${SqliteTask.columnPriority} integer not null,
                ${SqliteTask.columnStatus} integer not null,
                ${SqliteTask.columnDeadline} text,
                ${SqliteTask.columnCreatedAt} text not null
              )
            ''');
          },
        ));

    tasks.open();
  }

  @override
  Future<void> close() async {
    await _db.close();

    tasks.close();

    if (io.Platform.environment.containsKey("FLUTTER_TEST")) {
      await deleteDatabase(inMemoryDatabasePath);
    }
  }
}
