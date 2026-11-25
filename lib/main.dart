import 'package:chirp/chirp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tarot_magic_by_chitra_222/router.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/todos/presentation/bloc/todo_bloc.dart';
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
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
        builder: (context,child) {
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
                theme: ThemeData(
                  textTheme: TextTheme(
                    displayLarge: GoogleFonts.interTextTheme().displayLarge,
                    displayMedium: GoogleFonts.interTextTheme().displayMedium,
                    displaySmall: GoogleFonts.interTextTheme().displaySmall,
                    labelLarge: GoogleFonts.interTextTheme().labelLarge,
                    labelMedium: GoogleFonts.interTextTheme().labelMedium,
                    labelSmall: GoogleFonts.interTextTheme().labelSmall,
                  )
                ),
                title: 'Tarot-Chitra-222',
                routerConfig: appRouter.router,
                debugShowCheckedModeBanner: false,
              );
            }),
          );
        }
    );
  }
}
