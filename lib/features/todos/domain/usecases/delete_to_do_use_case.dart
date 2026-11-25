

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/todos_repository.dart';

class DeleteToDoUseCase implements UseCase<bool,int>{
  final TodosRepository todosRepository;
  DeleteToDoUseCase({required this.todosRepository});
  @override
  Future<Either<Failure, bool>> call(int params) async{
    return await todosRepository.deleteToDo(id: params);
  }

}