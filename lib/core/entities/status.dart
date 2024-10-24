import 'package:flutter/material.dart';

typedef StatusData = (String, IconData);

class Status {
  static const int doing = 1, blocked = 2, completed = 3;

  static const _statusValues = <int, StatusData>{
    doing: ("In progress", Icons.check_box_outline_blank),
    blocked: ("Blocked", Icons.block),
    completed: ("Completed", Icons.check_box),
  };

  StatusData? getStatusFromID(int id) {
    return _statusValues[id];
  }
}
