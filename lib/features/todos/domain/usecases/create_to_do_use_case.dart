import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/to_do_entity.dart';
import '../repository/todos_repository.dart';

class CreateToDoUseCase implements UseCase<ToDoEntity, ToDoParams>{
  final TodosRepository toDoRepository;
  CreateToDoUseCase({required this.toDoRepository});
  @override
  Future<Either<Failure, ToDoEntity>> call(ToDoParams params) async{
    return await toDoRepository.createToDo(todo: params.todo, userId: params.userId);
  }
}

class ToDoParams{
  final String todo;
  final String userId;

  ToDoParams({required this.todo, required this.userId});
}