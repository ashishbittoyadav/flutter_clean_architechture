import 'package:dio/dio.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(int id);
}

class TodoRemoteSourceImpl implements TodoRemoteSource{
    final Dio dio;
    TodoRemoteSourceImpl({required this.dio});

  @override
  Future<TodoModel> addTodo(TodoModel todo) async{
    Future.delayed(Duration(seconds: 2));
    return TodoModel(id: 42, todo: 'todo', userId: 140, completed: false);
  }

  @override
  Future<void> deleteTodo(int id) async{
    Future.delayed(Duration(seconds: 2));
  }

  @override
  Future<List<TodoModel>> getTodos() async{
    return await dio.get('todos').then((value) => (value.data['todos'] as List)
        .map((e) => TodoModel.fromJson(e))
        .toList());
    // try {
    //   final response = await dio.get('todos');
    //
    //   print('STATUS: ${response.statusCode}');
    //   print('DATA TYPE: ${response.data.runtimeType}');
    //   print('DATA: ${response.data}');
    //
    //   final todos = response.data['todos'] as List;
    //
    //   final result = todos
    //       .map((e) => TodoModel.fromJson(e))
    //       .toList();
    //
    //   print('PARSED TODOS: ${result.length}');
    //
    //   return result;
    // } catch (e, stackTrace) {
    //   print('🔥 DATASOURCE EXCEPTION: $e');
    //   print('🔥 STACKTRACE: $stackTrace');
    //   rethrow;
    // }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async{
    Future.delayed(Duration(seconds: 2));
    return todo;
  }
}