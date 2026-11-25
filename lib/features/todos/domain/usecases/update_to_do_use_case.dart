
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/to_do_entity.dart';
import '../repository/todos_repository.dart';

class UpdateToDoUseCase implements UseCase<ToDoEntity,int>{
  final TodosRepository todosRepository;
  UpdateToDoUseCase({required this.todosRepository});
  @override
  Future<Either<Failure, ToDoEntity>> call(int params) async{
    return await todosRepository.updateToDo(id: params);
  }

}