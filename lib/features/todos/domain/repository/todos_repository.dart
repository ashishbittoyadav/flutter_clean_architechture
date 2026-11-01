
import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/features/todos/domain/entity/to_do_entity.dart';

abstract class TodosRepository {
  Future<Either<Failure,List<ToDoEntity>>> fetchTodos();
  Future<Either<Failure,ToDoEntity>> updateToDo({required int id});
  Future<Either<Failure,bool>> deleteToDo({required int id});
  Future<Either<Failure,ToDoEntity>> createToDo({required String todo,required String userId});
}