import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/bloc/todo_bloc.dart';
import 'package:myapp/model/todo_model.dart';
import 'package:myapp/views/widgets/app_input_text_field_widget.dart';
import 'package:myapp/views/widgets/custom_delete_confirm_dialog.dart';
import 'package:myapp/views/widgets/show_app_snack_bar.dart';
import 'package:myapp/views/widgets/todo_list_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  late TodoModel todoItem = TodoModel(id: '', title: '', isCompleted: false);
  List<TodoModel> todoList = [];
  late Timer _searchTime;
  bool isEdit = false;
  bool isLoading = true;

  @override
  void initState() {
    isLoading = true;
    _searchTime = Timer(const Duration(milliseconds: 10), () {});
    super.initState();
  }

  @override
  void dispose() {
    _searchTime.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..add(LoadTodosEven()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Todos (BLoC)'), centerTitle: true),
          body: BlocConsumer<TodoBloc, TodoState>(
            listener: (contextBT, state) {
              if (state is TodoLoaded) {
                /// bloc load todo list success
                todoList = state.todos;
                isLoading = false;
              }
              if (state is TodoFiltered) {
                /// bloc search filter success
                todoList = state.filteredTodos;
              }
              if (state is TodoDoublicatData) {
                /// bloc doublicat data
                ShowAppSnackBar.showSnakeBar(
                  context: context,
                  title: state.message,
                );
              }
              if (state is SelectEditTodoStare) {
                /// bloc select for edit
                isEdit = state.isEdit;
                todoItem = state.itemEdit;
                titleController.text = todoItem.title;
              }
              if (state is AddTodoSuccessState) {
                /// bloc add todo success
                titleController.clear();
                FocusScope.of(context).requestFocus(FocusNode());
                contextBT.read<TodoBloc>().add(LoadTodosEven());
              }
              if (state is UpdateTodoSuccessState) {
                /// bloc updat todo success
                titleController.clear();
                todoItem = TodoModel(id: '', title: '', isCompleted: false);
                isEdit = false;
                FocusScope.of(context).requestFocus(FocusNode());
                contextBT.read<TodoBloc>().add(LoadTodosEven());
              }

              /// bloc delete todo success
              if (state is DeletTodoSuccessState) {
                /// bloc check delete the same item edit
                if (isEdit &&
                    todoItem.id.isNotEmpty &&
                    todoItem.id == state.itemId) {
                  titleController.clear();
                  todoItem = TodoModel(id: '', title: '', isCompleted: false);
                  isEdit = false;
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                contextBT.read<TodoBloc>().add(LoadTodosEven());
              }
            },
            builder: (contextBT, state) {
              if (isLoading) {
                /// bloc loading todo list
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoError) {
                /// bloc load todo list error
                return Center(child: Text(state.message));
              }
              return Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    /// bloc search filter
                    Row(
                      children: [
                        Expanded(
                          child: AppInputTextFieldWidget(
                            controller: searchController,
                            hintText: 'Search',
                            leftIcon: true,
                            onChange: (String value) {
                              _searchTime
                                  .cancel(); // Cancel the previous timer when the text changes
                              _searchTime = Timer(const Duration(seconds: 1), () {
                                contextBT.read<TodoBloc>().add(
                                  SearchTodoEvent(value),
                                );
                              });
                            },
                            onSubmitted: (String value) {},
                          ),
                        ),
                        SizedBox(width: 10,),
                        TextButton(
                          onPressed: () {
                            contextBT.read<TodoBloc>().add(SearchFilterTodoEvent(isFilterByDes: false));
                          },
                          child: const Text('Filter by Des', style: TextStyle(color: Colors.deepPurple)),
                        ),
                        SizedBox(width: 10,),
                        TextButton(
                          onPressed: () {
                            contextBT.read<TodoBloc>().add(SearchFilterTodoEvent(isFilterByDes: true));
                          },
                          child: const Text('Filter by Ass', style: TextStyle(color: Colors.pink)),
                        ),
                      
                      ],
                    ),


                    /// bloc add or update
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppInputTextFieldWidget(
                              controller: titleController,
                              hintText: 'Input title',
                              onChange: (String value) {},
                              onSubmitted: (String value) {},
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              /// bloc no text input
                              if (titleController.text.trim().isEmpty) {
                                ShowAppSnackBar.showSnakeBar(
                                  context: context,
                                  title: "Please input title",
                                );
                                return;
                              }
                              if (isEdit) {
                                contextBT.read<TodoBloc>().add(
                                  UpdateTodoEvent(
                                    id: todoItem.id,
                                    title: titleController.text.trim(),
                                  ),
                                );
                              } else {
                                /// bloc add todo list
                                contextBT.read<TodoBloc>().add(
                                  AddTodoEvent(titleController.text.trim()),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: isEdit ? Colors.blue : Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              child: Text(
                                isEdit ? "Update" : 'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// bloc todo list
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state is TodoLoading) {
                            /// bloc loading todo list
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (todoList.isEmpty) {
                            return const Center(
                              child: Text(
                                'No result. Create a new one instead',
                              ),
                            );
                          }
                          return TodoListWidget(
                            todoList: todoList,
                            onChangeCheckbox: (bool? value, String id) {
                              contextBT.read<TodoBloc>().add(
                                ToggleTodoEvent(id, value ?? false),
                              );
                            },
                            onUpdateTodo: (TodoModel data) {
                              contextBT.read<TodoBloc>().add(
                                SelectEditTodoEvent(
                                  isEdit: true,
                                  itemEdit: data,
                                ),
                              );
                            },
                            onDeleteTodo: (String id) {
                              CustomDeleteConfirmDialog.show(
                                context: context,
                                onConfirm: () {
                                  contextBT.read<TodoBloc>().add(
                                    DeleteTodoEvent(id),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
