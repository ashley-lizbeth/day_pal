import 'package:flutter/material.dart';

enum StatusKey { doing, blocked, completed }

StatusKey _getStatusKeyFromString(String str) {
  return StatusKey.values.firstWhere((e) => e.toString() == 'StatusKey.$str');
}

class Status implements Comparable<Status> {
  late StatusKey key;

  late String name;
  late IconData icon;

  Status(String keyStr) {
    key = _getStatusKeyFromString(keyStr);

    var statusValues = _getPredeterminedValuesFromKey();
    name = statusValues.$1;
    icon = statusValues.$2;
  }

  int _getKeyValue() {
    if (key == StatusKey.completed) return 3;
    if (key == StatusKey.blocked) return 2;
    return 1;
  }

  (String, IconData) _getPredeterminedValuesFromKey() {
    if (key == StatusKey.completed) {
      return ("Completed", Icons.check_box);
    }

    if (key == StatusKey.blocked) return ("Blocked", Icons.block);

    return ("In progress", Icons.check_box_outline_blank);
  }

  @override
  int compareTo(Status other) {
    if (key == other.key) return 0;
    return _getKeyValue() < other._getKeyValue() ? 1 : -1;
  }
}
