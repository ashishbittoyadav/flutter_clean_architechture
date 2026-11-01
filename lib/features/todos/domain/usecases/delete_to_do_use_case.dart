

import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/core/usecases/usecase.dart';
import 'package:flutter_architecture_poc/features/todos/domain/repository/todos_repository.dart';

class DeleteToDoUseCase implements UseCase<bool,int>{
  final TodosRepository todosRepository;
  DeleteToDoUseCase({required this.todosRepository});
  @override
  Future<Either<Failure, bool>> call(int params) async{
    return await todosRepository.deleteToDo(id: params);
  }

}