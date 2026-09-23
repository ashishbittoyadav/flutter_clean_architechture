import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/core/usecases/usecase.dart';
import 'package:flutter_architecture_poc/features/todos/domain/repository/todos_repository.dart';

class DeleteToDoUseCase implements UseCase<bool,Int>{
  final TodosRepository todosRepository;
  DeleteToDoUseCase({required this.todosRepository});
  @override
  Future<Either<Failure, bool>> call(Int params) async{
    return await todosRepository.deleteToDo(id: params);
  }

}