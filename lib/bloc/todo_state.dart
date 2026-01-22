part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoModel> todos;

  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);
}

class TodoDoublicatData extends TodoState {
  final String message;

  TodoDoublicatData(this.message);
}

/// Filtered result state
class TodoFiltered extends TodoState {
  final List<TodoModel> filteredTodos;
  TodoFiltered(this.filteredTodos);
}

class SelectEditTodoStare extends TodoState {
  final bool isEdit;
  final TodoModel itemEdit;
  SelectEditTodoStare({required this.isEdit, required this.itemEdit});
}
