import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Day Pal: loading...",
      home: Scaffold(
        body: Center(
          child: SpinKitWanderingCubes(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
