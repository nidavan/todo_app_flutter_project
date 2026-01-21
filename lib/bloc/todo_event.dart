part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}
class LoadTodosEven extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;

  AddTodoEvent(this.title);
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final String title;

  UpdateTodoEvent({
    required this.id,
    required this.title,
  });
}

class ToggleTodoEvent extends TodoEvent {
  final String id;
  final bool isCompleted;

  ToggleTodoEvent(this.id, this.isCompleted);
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent(this.id);
}

class SearchTodoEvent extends TodoEvent {
  final String query;
  SearchTodoEvent(this.query);
}

