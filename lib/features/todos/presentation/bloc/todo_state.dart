import 'package:equatable/equatable.dart';

import '../../domain/entity/to_do_entity.dart';

abstract class TodoState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState{}
class TodoLoading extends TodoState{}
class TodoList extends TodoState{
  final List<ToDoEntity> todos;
  TodoList({required this.todos});
  @override
  List<Object?> get props => [todos];
}
class TodoError extends TodoState{
  final String message;
  TodoError({required this.message});
  @override
  List<Object?> get props => [message];
}