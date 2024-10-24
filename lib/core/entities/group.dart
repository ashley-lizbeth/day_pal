class Group {
  final String id;
  String name;
  String description = "";

  DateTime createdAt = DateTime.now();

  Group(this.id, this.name);
}
