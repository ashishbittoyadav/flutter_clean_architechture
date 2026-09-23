import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/core/usecases/usecase.dart';
import 'package:flutter_architecture_poc/features/todos/domain/entity/to_do_entity.dart';
import 'package:flutter_architecture_poc/features/todos/domain/repository/todos_repository.dart';

class UpdateToDoUseCase implements UseCase<ToDoEntity,Int>{
  final TodosRepository todosRepository;
  UpdateToDoUseCase({required this.todosRepository});
  @override
  Future<Either<Failure, ToDoEntity>> call(Int params) async{
    return await todosRepository.updateToDo(id: params);
  }

}