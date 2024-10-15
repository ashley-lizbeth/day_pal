import 'package:flutter_todo/core/dataproviders/in-memory/InMemoryTask/repository.dart';
import 'package:flutter_todo/core/entities/task.dart';

class InMemoryTask extends Task {
  final InMemoryTaskRepository _dataprovider;

  InMemoryTask(super.id, super.title, this._dataprovider);

  InMemoryTask.from(Task task, super.id, super.title, this._dataprovider) {
    priority = task.priority;

    status = task.status;
    reasonForStatus = task.reasonForStatus;

    createdAt = task.createdAt;
    deadline = task.deadline;
  }

  @override
  bool save() {
    return _dataprovider.update(super.id, super.getSelf());
  }

  @override
  bool delete() {
    return _dataprovider.delete(super.id);
  }
}
