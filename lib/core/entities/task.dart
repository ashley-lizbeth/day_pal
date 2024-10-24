import 'package:flutter_todo/core/entities/status.dart';

class Task implements Comparable<Task> {
  final String id;

  String title;

  int priority = 3;

  Status status = Status.doing;

  DateTime createdAt = DateTime.now();
  DateTime? deadline;

  Task(this.id, this.title);

  Task.from(Task task, this.id, this.title) {
    priority = task.priority;

    status = task.status;

    createdAt = task.createdAt;
    deadline = task.deadline;
  }

  Task getSelf() {
    return Task.from(this, id, title);
  }

  bool? hasExpired() {
    return deadline?.isBefore(createdAt);
  }

  bool isHigherPriority(Task taskToCompare) {
    return priority < taskToCompare.priority;
  }

  bool save() {
    return false;
  }

  bool delete() {
    return false;
  }

  @override
  int compareTo(Task other) {
    var statusComparison = status.index.compareTo(other.status.index);
    if (statusComparison != 0) return statusComparison;

    var priorityComparison = priority.compareTo(other.priority);
    if (priorityComparison != 0) return priorityComparison;

    if (deadline == null) {
      if (other.deadline != null) return -1;
      return 0;
    }

    if (other.deadline == null) return 1;

    if (deadline!.isAfter(other.deadline!)) return -1;
    if (deadline!.isBefore(other.deadline!)) return 1;

    return title.compareTo(other.title);
  }

  @override
  int get hashCode =>
      Object.hash(id, title, priority, status, createdAt, deadline);

  @override
  bool operator ==(Object other) {
    return other is Task && other.hashCode == hashCode;
  }
}
