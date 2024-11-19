class Todo {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;
  String category;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    required this.category,
  });
}