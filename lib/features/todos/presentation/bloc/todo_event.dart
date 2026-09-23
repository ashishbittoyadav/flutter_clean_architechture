import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
class TodoFetch extends TodoEvent{}
class TodoUpdate extends TodoEvent{
  final int id;
  TodoUpdate({required this.id});
  @override
  List<Object?> get props => [id];
}
class TodoDelete extends TodoEvent{
  final int id;
  TodoDelete({required this.id});
  @override
  List<Object?> get props => [id];
}
class TodoCreate extends TodoEvent{
  final String todo;
  final int userId;
  TodoCreate({required this.todo, required this.userId});
  @override
  List<Object?> get props => [todo,userId];
}