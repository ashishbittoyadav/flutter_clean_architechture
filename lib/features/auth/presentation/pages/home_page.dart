import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [IconButton(onPressed: (){
          context.read<AuthBloc>().add(AuthLogoutRequested());
        }, icon: Icon(Icons.logout))],
      ),
      body: BlocBuilder<AuthBloc,AuthState>(builder: (context,state){
        if(state is AuthAuthenticated){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                size: 100,
                color: Colors.green,),
                SizedBox(height: 24,),
                Text('Welcome',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                SizedBox(height: 16,),
                Text('Email: ${state.user.email}'),
                SizedBox(height: 16,),
                Text('Name: ${state.user.name}'),
                SizedBox(height: 32,),
                ElevatedButton(onPressed: (){
                  context.go('/todos');
                }, child: Text('Go To Todos')),
                SizedBox(height: 32,),
                ElevatedButton(onPressed: (){
                  context.read<AuthBloc>().add(AuthCheckRequested());
                }, child: Text('Fetch secure data')),
                ElevatedButton(onPressed: (){
                  context.push('/sliver_screen');
                }, child: Text('Go to Sliver Screen'))
              ],
            ),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
