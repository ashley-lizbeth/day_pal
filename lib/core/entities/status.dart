import 'package:flutter/material.dart';

class Status implements Comparable<Status> {
  static const String doing = "doing",
      blocked = "blocked",
      completed = "completed";

  static List<Status> asList() {
    List<Status> statusList = [
      Status(doing),
      Status(blocked),
      Status(completed)
    ];
    statusList.sort();
    return statusList;
  }

  String key;

  late String name;
  late Icon icon;

  Status(this.key) {
    var statusValues = _getPredeterminedValuesFromKey();
    name = statusValues.$1;
    icon = statusValues.$2;
  }

  int _getKeyValue() {
    if (key == completed) return 3;
    if (key == blocked) return 2;
    return 1;
  }

  (String, Icon) _getPredeterminedValuesFromKey() {
    if (key == completed) {
      return (
        "Completed",
        Icon(
          Icons.check_box,
          color: Colors.green,
        )
      );
    }

    if (key == blocked) {
      return (
        "Blocked",
        Icon(
          Icons.block,
          color: Colors.red[800],
        )
      );
    }

    if (key == doing) {
      return ("In progress", Icon(Icons.check_box_outline_blank));
    }

    return ("", Icon(Icons.warning));
  }

  @override
  int compareTo(Status other) {
    if (key == other.key) return 0;
    return _getKeyValue() < other._getKeyValue() ? -1 : 1;
  }

  @override
  int get hashCode => Object.hash(key, name);

  @override
  bool operator ==(Object other) {
    return other is Status && other.hashCode == hashCode;
  }
}
