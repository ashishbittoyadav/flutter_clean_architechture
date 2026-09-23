import 'package:dartz/dartz.dart';

import 'package:flutter_architecture_poc/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}
