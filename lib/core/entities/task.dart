class Task implements Comparable<Task> {
  final String id;

  String title;

  String description = "";
  String groupID = "";
  List<String> tagsIDs = [];

  int priority = 3;
  int status = 1;

  DateTime createdAt = DateTime.now();
  DateTime? deadline;

  Task(this.id, this.title);

  void copy(Task from, Task to) {
    to.description = from.description;
    to.groupID = from.groupID;
    to.tagsIDs = from.tagsIDs;

    to.priority = from.priority;
    to.status = from.status;

    to.createdAt = from.createdAt;
    to.deadline = from.deadline;
  }

  Task getSelf() {
    Task copyOfSelf = Task(id, title);
    copy(this, copyOfSelf);
    return copyOfSelf;
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
    var statusComparison = status.compareTo(other.status);
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
