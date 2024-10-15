import 'package:flutter/material.dart';

enum Status { doing, blocked, completed }

typedef StatusData = (String, IconData);

const statusValues = <Status, StatusData>{
  Status.doing: ("In progress", Icons.check_box_outline_blank),
  Status.blocked: ("Blocked", Icons.block),
  Status.completed: ("Completed", Icons.check_box),
};

StatusData getStatusData(Status status) {
  return statusValues[status]!;
}
