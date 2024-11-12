import 'package:flutter/material.dart';
import 'package:day_pal/database_context.dart';
import 'package:day_pal/screens/tasks_screen/main.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return DatabaseContext(
        child: MaterialApp(
      home: TasksScreen(),
    ));
  }
}
