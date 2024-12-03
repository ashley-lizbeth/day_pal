import 'package:flutter/material.dart';

class Status implements Comparable<Status> {
  static const int doing = 1, blocked = 2, completed = 3;

  static List<Status> asList() {
    List<Status> statusList = [
      Status(doing),
      Status(blocked),
      Status(completed)
    ];
    statusList.sort();
    return statusList;
  }

  int key;

  late String name;
  late Icon icon;

  Status(this.key) {
    var statusValues = _getPredeterminedValuesFromKey();
    name = statusValues.$1;
    icon = statusValues.$2;
  }

  (String, Icon) _getPredeterminedValuesFromKey() {
    String message = "";
    IconData icon = Icons.warning;
    Color? color = Colors.yellow;

    if (key == completed) {
      message = "Completed";
      icon = Icons.check_box;
      color = Colors.green;
    }

    if (key == blocked) {
      message = "Blocked";
      icon = Icons.block;
      color = Colors.red[800];
    }

    if (key == doing) {
      message = "In progress";
      icon = Icons.check_box_outline_blank;
      color = null;
    }

    return (
      message,
      Icon(
        icon,
        color: color,
        size: 40,
      )
    );
  }

  @override
  int compareTo(Status other) {
    return key.compareTo(other.key);
  }

  @override
  int get hashCode => Object.hash(key, name);

  @override
  bool operator ==(Object other) {
    return other is Status && other.hashCode == hashCode;
  }
}
