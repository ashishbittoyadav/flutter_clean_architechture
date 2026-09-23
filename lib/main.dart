import 'package:chirp/chirp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_poc/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_architecture_poc/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Chirp.root = ChirpLogger()
  .addConsoleWriter(formatter: RainbowMessageFormatter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<TodoBloc>(
          create: (_) => di.sl<TodoBloc>(),
        ),
      ],
      child: Builder(builder: (context) {
        final authBloc = context.read<AuthBloc>();
        final appRouter = AppRouter(authBloc: authBloc);
        return MaterialApp.router(
          title: 'Simple Demo',
          routerConfig: appRouter.router,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
