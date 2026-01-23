import 'package:flutter/material.dart';
import 'package:myapp/model/todo_model.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoModel> todoList;
  final Function(bool? value, String id) onChangeCheckbox;
  final Function(TodoModel data) onUpdateTodo;
  final Function(String id) onDeleteTodo;

  const TodoListWidget({
    super.key,
    required this.todoList,
    required this.onChangeCheckbox,
    required this.onUpdateTodo,
    required this.onDeleteTodo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        final todo = todoList[index];
        return Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (val) {
                    onChangeCheckbox(val, todo.id);
                  },
                ),
                Expanded(
                  child: Text(
                    todo.title,
                     style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,  
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        onUpdateTodo(todo);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        onDeleteTodo(todo.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey,)
          ],
        );
      },
    );
  }
}
