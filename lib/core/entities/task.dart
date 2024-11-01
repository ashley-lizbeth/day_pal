import 'package:flutter_todo/core/entities/priority.dart';
import 'package:flutter_todo/core/entities/status.dart';

class Task implements Comparable<Task> {
  final String id;

  String title;

  String description = "";
  String groupID = "";
  List<String> tagsIDs = [];

  int priorityValue = 3;
  Priority priority() {
    return Priority(priorityValue);
  }

  String statusKey = Status.doing;
  Status status() {
    return Status(statusKey);
  }

  DateTime createdAt = DateTime.now();
  DateTime? deadline;

  Task(this.id, this.title);

  void copyFrom(Task from) {
    description = from.description;
    groupID = from.groupID;
    tagsIDs = from.tagsIDs;

    priorityValue = from.priorityValue;
    statusKey = from.statusKey;

    createdAt = from.createdAt;
    deadline = from.deadline;
  }

  Task getSelf() {
    Task copyOfSelf = Task(id, title);
    copyOfSelf.copyFrom(this);
    return copyOfSelf;
  }

  bool? hasExpired() {
    return deadline?.isBefore(createdAt);
  }

  bool isHigherPriority(Task taskToCompare) {
    return priorityValue < taskToCompare.priorityValue;
  }

  bool save() {
    return false;
  }

  bool delete() {
    return false;
  }

  @override
  int compareTo(Task other) {
    var statusComparison = Status(statusKey).compareTo(Status(other.statusKey));
    if (statusComparison != 0) return statusComparison;

    var priorityComparison =
        Priority(priorityValue).compareTo(Priority(priorityValue));
    if (priorityComparison != 0) return priorityComparison;

    if (deadline == null) {
      if (other.deadline != null) return -1;
      return 0;
    }

    if (other.deadline == null) return 1;

    if (deadline!.isAfter(other.deadline!)) return -1;
    if (deadline!.isBefore(other.deadline!)) return 1;

    var titleComparison = title.compareTo(other.title);
    if (titleComparison != 0) return titleComparison;

    return description.compareTo(other.description);
  }

  @override
  int get hashCode =>
      Object.hash(id, title, priorityValue, statusKey, createdAt, deadline);

  @override
  bool operator ==(Object other) {
    return other is Task && other.hashCode == hashCode;
  }
}
