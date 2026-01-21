class TodoModel {
  final String id;
  final String title;
  final bool isCompleted;

  TodoModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
    );
  }
}
