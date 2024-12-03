import 'package:day_pal/core/entities/priority.dart';
import 'package:day_pal/core/entities/status.dart';
import 'package:day_pal/core/utils/get_date_without_time.dart';

class Task implements Comparable<Task> {
  final String id;

  String title = "";

  String description = "";
  String groupID = "";
  List<String> tagsIDs = [];

  int priorityValue = 3;
  Priority priority() {
    return Priority(priorityValue);
  }

  int statusKey = Status.doing;
  Status status() {
    return Status(statusKey);
  }

  DateTime createdAt = DateTime.now();
  DateTime? deadline;

  Task(this.id);

  void copyFrom(Task from) {
    title = from.title;
    description = from.description;
    groupID = from.groupID;
    tagsIDs = from.tagsIDs;

    priorityValue = from.priorityValue;
    statusKey = from.statusKey;

    createdAt = from.createdAt;
    deadline = from.deadline;
  }

  Task getSelf() {
    Task copyOfSelf = Task(id);
    copyOfSelf.copyFrom(this);
    return copyOfSelf;
  }

  bool hasExpired() {
    if (deadline == null) return false;
    return deadline!.isBefore(DateTime.now());
  }

  bool expiresToday() {
    if (deadline == null) return false;
    return getDateWithoutTime(deadline!) == getToday();
  }

  bool isHigherPriority(Task taskToCompare) {
    return priorityValue < taskToCompare.priorityValue;
  }

  @override
  int compareTo(Task other) {
    final statusComparison = statusKey.compareTo(other.statusKey);
    if (statusComparison != 0) return statusComparison;

    if (deadline == null) {
      if (other.deadline != null) return 1;
      return 0;
    }

    if (other.deadline == null) return -1;

    if (deadline!.isAfter(other.deadline!)) return 1;
    if (deadline!.isBefore(other.deadline!)) return -1;

    final priorityComparison = priorityValue.compareTo(other.priorityValue);
    if (priorityComparison != 0) return priorityComparison;

    final titleComparison = title.compareTo(other.title);
    if (titleComparison != 0) return titleComparison;

    final descriptionComparison = description.compareTo(other.description);
    if (descriptionComparison != 0) return descriptionComparison;

    return createdAt.compareTo(other.createdAt);
  }

  @override
  int get hashCode =>
      Object.hash(id, title, priorityValue, statusKey, createdAt, deadline);

  @override
  bool operator ==(Object other) {
    return other is Task && other.hashCode == hashCode;
  }
}
