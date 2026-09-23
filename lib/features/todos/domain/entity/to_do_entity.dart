import 'dart:ffi';

import 'package:equatable/equatable.dart';

class ToDoEntity extends Equatable{
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const ToDoEntity({required this.id, required this.todo, required this.completed, required this.userId});

  @override
  List<Object?> get props => [id,todo,completed,userId];
}