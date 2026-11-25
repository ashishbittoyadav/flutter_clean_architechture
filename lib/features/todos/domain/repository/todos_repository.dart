
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/to_do_entity.dart';

abstract class TodosRepository {
  Future<Either<Failure,List<ToDoEntity>>> fetchTodos();
  Future<Either<Failure,ToDoEntity>> updateToDo({required int id});
  Future<Either<Failure,bool>> deleteToDo({required int id});
  Future<Either<Failure,ToDoEntity>> createToDo({required String todo,required String userId});
}