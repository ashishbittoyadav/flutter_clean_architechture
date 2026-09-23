import '../../domain/entity/to_do_entity.dart';

class TodoModel extends ToDoEntity {
  const TodoModel({
    required super.id,
    required super.todo,
    required super.userId,
    required super.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      todo: json['todo'],
      userId: json['userId'],
      completed: json['completed'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'todo':todo,
      'userId':userId,
      'completed':completed
    };
  }
}
