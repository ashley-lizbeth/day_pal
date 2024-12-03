import 'package:flutter/material.dart';

import 'package:day_pal/screens/loading_screen.dart';

import 'package:day_pal/core/repositories/database_wrapper.dart';
import 'package:day_pal/core/dataproviders/init.dart';

class DatabaseContext extends StatefulWidget {
  static InheritedDatabase? of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<InheritedDatabase>();

  final Widget child;

  const DatabaseContext({super.key, required this.child});

  @override
  State<DatabaseContext> createState() => _DatabaseContextState();
}

class _DatabaseContextState extends State<DatabaseContext> {
  final DatabaseWrapper db = initializeDatabaseWrapperBasedOnEnvironment();

  bool isDBOpen = false;

  void openDatabase() async {
    await db.open();
    setState(() {
      isDBOpen = true;
    });
  }

  void closeDatabase() async {
    setState(() {
      isDBOpen = false;
    });
    await db.close();
  }

  @override
  void initState() {
    super.initState();
    openDatabase();
  }

  @override
  void dispose() {
    super.dispose();
    closeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDBOpen) return LoadingScreen();
    return InheritedDatabase(db: db, child: widget.child);
  }
}

class InheritedDatabase extends InheritedWidget {
  final DatabaseWrapper db;

  const InheritedDatabase({
    super.key,
    required super.child,
    required this.db,
  });

  static InheritedDatabase? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDatabase>();
  }

  static InheritedDatabase of(BuildContext context) {
    final db = maybeOf(context);
    assert(db != null, 'No InheritedDatabase found in context');
    return db!;
  }

  @override
  bool updateShouldNotify(InheritedDatabase oldWidget) {
    return oldWidget.db != db;
  }
}
