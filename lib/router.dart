import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_architecture_poc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_architecture_poc/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_architecture_poc/features/todos/presentation/pages/sliver_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/todos/presentation/bloc/todo_bloc.dart';
import 'features/todos/presentation/pages/todo_page.dart';
import 'injection_container.dart' as di;

class AppRouter{
    final AuthBloc authBloc;

    AppRouter({required this.authBloc});

    GoRouter get router =>  GoRouter(
        initialLocation: '/splash',
        refreshListenable: GoRouterRefreshStream(authBloc.stream),
        redirect: (context,state){
          final authState = authBloc.state;

          final isGoingToLogin = state.matchedLocation == '/login';
          final isGoingToSplash = state.matchedLocation == '/splash';

          if(authState is AuthUnauthenticated || authState is AuthError){
            return isGoingToLogin ? null : '/login';
          }
          if(authState is AuthAuthenticated){
            if(isGoingToSplash || isGoingToLogin){
              return '/home';
            }
          }
          return null;
        },
        routes: [
          GoRoute(path: '/splash',builder: (context,state){
            return const SplashPage();
          }),
          GoRoute(path: '/login',builder: (context,state){
            return const LoginPage();
          }),
          GoRoute(path: '/home',builder: (context,state){
            return const HomePage();
          }),
          GoRoute(path: '/todos',
            builder: (context, state) {
              return BlocProvider<TodoBloc>(
                create: (_) => di.sl<TodoBloc>(),
                child: const TodoPage(),
              );
            },
          ),
          GoRoute(path: '/sliver_screen',
            builder: (context, state) {
              return BlocProvider<TodoBloc>(
                create: (_) => di.sl<TodoBloc>(),
                child: const SliverScreen(),
              );
            },
          )
        ]
    );
}

class GoRouterRefreshStream extends ChangeNotifier{

  GoRouterRefreshStream(Stream stream){
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }


}