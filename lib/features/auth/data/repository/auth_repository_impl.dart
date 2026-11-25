import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource, required this.authLocalDataSource});

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async{
    try{
      final user = await authLocalDataSource.getCachedUser();
      if(user!=null){
        return Right(user);
      }else{
        return Left(CacheFailure());
      }
    }catch(e){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async{
    try{
      final token = await authLocalDataSource.getCachedToken();
      return Right(token!=null);
    }catch(e){
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async{
    try{
      final user = await authRemoteDataSource.login(email, password);
      await authLocalDataSource.cacheToken("mock_token_${user.id}");
      await authLocalDataSource.cacheUser(user);
      return Right(user);
    }on InvalidCredentialsFailure{
      return Left(InvalidCredentialsFailure());
    }on ServerException{
      return Left(ServerFailure());
    }catch(e){
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async{
    try{
      await authRemoteDataSource.logout();
      await authLocalDataSource.clearToken();
      return Right(null);
    }catch(e){
      return Left(ServerFailure());
    }
  }

}