import 'package:myapp/model/todo_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class TodoRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<TodoModel>> fetchTodos() async {
    final res = await _client
        .from('todos')
        .select()
        .order('title', ascending: true);

    return (res as List).map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<void> addTodo(String title) async {
    await _client.from('todos').insert({
      'title': title,
      'is_completed': false,
    });
  }

  Future<void> updateTodo({
    required String id,
    required String title,
  }) async {
    await _client.from('todos').update({
      'title': title,
    }).eq('id', id);
  }

  Future<void> toggleTodo(String id, bool isCompleted) async {
    await _client
        .from('todos')
        .update({'is_completed': isCompleted})
        .eq('id', id);
  }

  Future<void> deleteTodo(String id) async {
    await _client.from('todos').delete().eq('id', id);
  }

    Future<List<TodoModel>> fetchFiterbyTodos(bool isAscending) async {
    final res = await _client
        .from('todos')
        .select()
        .order('title', ascending: isAscending);

    return (res as List).map((e) => TodoModel.fromJson(e)).toList();
  }
}
