import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/to_do_entity.dart';
import '../repository/todos_repository.dart';

class FetchTodoUseCase implements UseCase<List<ToDoEntity>,void>{
  final TodosRepository todosRepository;
  FetchTodoUseCase({required this.todosRepository});
  @override
  Future<Either<Failure, List<ToDoEntity>>> call(void params) async{
    return await todosRepository.fetchTodos();
  }
}