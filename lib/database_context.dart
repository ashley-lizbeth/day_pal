import 'package:flutter/material.dart';
import 'package:day_pal/core/dataproviders/in-memory/in_memory_database.dart';
import 'package:day_pal/core/repositories/database_wrapper.dart';

class DatabaseContext extends StatefulWidget {
  static InheritedDatabase? of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<InheritedDatabase>();

  final Widget child;

  const DatabaseContext({super.key, required this.child});

  @override
  State<DatabaseContext> createState() => _DatabaseContextState();
}

class _DatabaseContextState extends State<DatabaseContext> {
  DatabaseWrapper db = InMemoryDatabase();

  void onDatabaseChange(DatabaseWrapper newDb) {
    setState(() async {
      await db.close();
      db = newDb;
    });
  }

  @override
  void initState() {
    super.initState();
    db.open();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedDatabase(
        db: db, onDatabaseChange: onDatabaseChange, child: widget.child);
  }
}

class InheritedDatabase extends InheritedWidget {
  final DatabaseWrapper db;
  final ValueChanged<DatabaseWrapper> onDatabaseChange;

  const InheritedDatabase({
    super.key,
    required super.child,
    required this.db,
    required this.onDatabaseChange,
  });

  static InheritedDatabase? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDatabase>();
  }

  @override
  bool updateShouldNotify(InheritedDatabase oldWidget) {
    return oldWidget.db != db || oldWidget.onDatabaseChange != onDatabaseChange;
  }
}
