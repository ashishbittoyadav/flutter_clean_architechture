import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_poc/features/auth/domain/entity/user_entity.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure,UserEntity>> login({required String email, required String password});

  Future<Either<Failure,void>> logout();

  Future<Either<Failure,UserEntity?>> getCurrentUser();

  Future<Either<Failure,bool>> isAuthenticated();
}