import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/service/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository = TodoRepository();

  TodoBloc() : super(TodoInitial()) {
    on<LoadTodosEven>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<SearchTodoEvent>(_onSearchTodo);

    on<SelectEditTodoEvent>((event, emit) {
     emit(SelectEditTodoStare(isEdit: event.isEdit, itemEdit: event.itemEdit));
    });
  }

  Future<void> _onLoadTodos(LoadTodosEven event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await repository.fetchTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }


  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());

      // 1️⃣ Fetch existing todos
      final todos = await repository.fetchTodos();

      // 2️⃣ Check for duplicate title
      final isDuplicate = todos.any(
        (todo) => todo.title.toLowerCase() == event.title.toLowerCase(),
      );

      if (isDuplicate) {
        emit(TodoDoublicatData('A todo with this title already exists!'));
        return;
      }

      // 3️⃣ Insert if no duplicate
      await repository.addTodo(event.title);

      add(LoadTodosEven());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());

      final todos = await repository.fetchTodos();

      // Exclude the current todo by ID
      final isDuplicate = todos.any(
        (todo) =>
            todo.id != event.id &&
            todo.title.toLowerCase() == event.title.toLowerCase(),
      );

      if (isDuplicate) {
        emit(TodoDoublicatData('A todo with this title already exists!'));
        return;
      }

      await repository.updateTodo(
        id: event.id,
        title: event.title,
      );

      add(LoadTodosEven());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await repository.toggleTodo(event.id, event.isCompleted);
      add(LoadTodosEven());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await repository.deleteTodo(event.id);
      add(LoadTodosEven());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onSearchTodo(
    SearchTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());

      final todos = await repository.fetchTodos();

      final filtered = todos.where((todo) {
        return todo.title.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(TodoFiltered(filtered));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
 
}
