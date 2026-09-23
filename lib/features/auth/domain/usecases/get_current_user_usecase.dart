import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/usecases/usecase.dart';
import 'package:flutter_architecture_poc/features/auth/domain/entity/user_entity.dart';

import '../../../../core/error/failures.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity?,NoParams>{
  final AuthRepository authRepository;

  GetCurrentUserUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async{
    return await authRepository.getCurrentUser();
  }
}