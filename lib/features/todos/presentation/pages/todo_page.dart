import 'package:chirp/chirp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_poc/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_architecture_poc/features/todos/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_event.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(TodoFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To Do List')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoList) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  key: Key(
                    '${state.todos[index].todo} ${state.todos[index].id}',
                  ),
                  title: Text(state.todos[index].todo),
                );
              },
            );
          }
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.home_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.person_outline)),
              IconButton(onPressed: (){}, icon: Icon(Icons.note_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.settings_outlined)),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (selected){
      //     Chirp.success('selected index: $selected');
      //   },
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.home_outlined),
      //       selectedIcon: Icon(Icons.home),
      //       label: 'home',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.person_outline),
      //       selectedIcon: Icon(Icons.person),
      //       label: 'profile',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.settings_outlined),
      //       selectedIcon: Icon(Icons.settings),
      //       label: 'settings',
      //     ),
      //   ],
      // ),
    );
  }
}
