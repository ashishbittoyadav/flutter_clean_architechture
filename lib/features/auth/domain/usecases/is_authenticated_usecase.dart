import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/core/usecases/usecase.dart';

import '../repository/auth_repository.dart';

class IsAuthenticatedUseCase implements UseCase<bool, NoParams>{
  final AuthRepository authRepository;
  IsAuthenticatedUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async{
    return await authRepository.isAuthenticated();
  }

}