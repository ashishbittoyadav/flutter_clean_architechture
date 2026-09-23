import 'dart:async';

import 'package:chirp/chirp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_architecture_poc/core/error/failures.dart';
import 'package:flutter_architecture_poc/core/usecases/usecase.dart';
import 'package:flutter_architecture_poc/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_architecture_poc/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:flutter_architecture_poc/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;

  AuthBloc({required this.loginUseCase, required this.logoutUseCase, required this.getCurrentUserUseCase, required this.isAuthenticatedUseCase}) : super(AuthInitial()){
    on<AuthCheckRequested>(_checkAuth);
    on<AuthLoginRequested>(_login);
    on<AuthLogoutRequested>(_logout);
  }

  FutureOr<void> _checkAuth(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await isAuthenticatedUseCase(NoParams());
    await result.fold((left){
      emit(AuthUnauthenticated());
    },(right)async{
      if(right){
        final user = await getCurrentUserUseCase(NoParams());
        Chirp.success('authenticated',data: {'user':user});
        await user.fold((left){
          emit(AuthUnauthenticated());
        }, (right){
          if(right!=null){
            emit(AuthAuthenticated(user: right));
          }else{
            emit(AuthUnauthenticated());
          }
        });
      }else{
        emit(AuthUnauthenticated());
      }
    });
  }

  FutureOr<void> _login(AuthLoginRequested event, Emitter<AuthState> emit) async{
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(email: event.email, password: event.password));
    
    result.fold((l){
      String message = 'Auth error';
      if(l is InvalidCredentialsFailure){
        message = 'Invalid credentials';
      }else if(l is ServerFailure){
        message = 'Server failure';
      }
      emit(AuthError(message: message));
    }, (r){
      emit(AuthAuthenticated(user: r));
    });
  }

  FutureOr<void> _logout(AuthLogoutRequested event, Emitter<AuthState> emit) async{
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold((l){
      emit(AuthError(message: 'Logout error'));
    }, (r){
      emit(AuthUnauthenticated());
    });
  }
}