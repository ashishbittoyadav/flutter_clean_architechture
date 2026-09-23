import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/features/todos/data/datasources/todo_remote_source.dart';
import 'package:flutter_architecture_poc/features/todos/domain/entity/to_do_entity.dart';
import 'package:flutter_architecture_poc/features/todos/domain/repository/todos_repository.dart';

class TodoRepositoryImpl implements TodosRepository{
  final TodoRemoteSource todoRemoteSource;

  TodoRepositoryImpl({required this.todoRemoteSource});

  @override
  Future<Either<Failure, ToDoEntity>> createToDo({required String todo, required String userId}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteToDo({required Int id}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ToDoEntity>>> fetchTodos() async{
    try{
      final todos = await todoRemoteSource.getTodos();
      return Right(todos);
    }on ServerFailure{
      return Left(ServerFailure());
    }catch(e){
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ToDoEntity>> updateToDo({required Int id}) {
    throw UnimplementedError();
  }

}