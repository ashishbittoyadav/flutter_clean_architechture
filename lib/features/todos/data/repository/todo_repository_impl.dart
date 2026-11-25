
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entity/to_do_entity.dart';
import '../../domain/repository/todos_repository.dart';
import '../datasources/todo_remote_source.dart';

class TodoRepositoryImpl implements TodosRepository{
  final TodoRemoteSource todoRemoteSource;

  TodoRepositoryImpl({required this.todoRemoteSource});

  @override
  Future<Either<Failure, ToDoEntity>> createToDo({required String todo, required String userId}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteToDo({required int id}) {
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
  Future<Either<Failure, ToDoEntity>> updateToDo({required int id}) {
    throw UnimplementedError();
  }

}