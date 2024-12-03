import 'dart:io' as io;

import 'package:day_pal/core/dataproviders/in-memory/in_memory_database.dart';
import 'package:day_pal/core/dataproviders/sqlite/sqlite_database.dart';
import 'package:day_pal/core/repositories/database_wrapper.dart';

DatabaseWrapper initializeDatabaseWrapperBasedOnEnvironment() {
  if (io.Platform.environment.containsKey("FLUTTER_TEST")) {
    return InMemoryDatabase();
  }

  return SqliteDatabase();
}
