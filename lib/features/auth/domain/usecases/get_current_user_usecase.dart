import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity?,NoParams>{
  final AuthRepository authRepository;

  GetCurrentUserUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async{
    return await authRepository.getCurrentUser();
  }
}