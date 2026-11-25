import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';

class SliverScreen extends StatefulWidget {
  const SliverScreen({super.key});

  @override
  State<SliverScreen> createState() => _SliverScreenState();
}

class _SliverScreenState extends State<SliverScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  // title: Text('Sliver App Bar'),
                  expandedHeight: 200,
                  floating: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    collapseMode: CollapseMode.parallax,
                    title: Text('Welcome'),
                    background: Image.network(
                      'https://www.google.com/imgres?q=mountains%20view%20image&imgurl=https%3A%2F%2Fhips.hearstapps.com%2Fhmg-prod%2Fimages%2Falpe-di-siusi-sunrise-with-sassolungo-or-langkofel-royalty-free-image-1623254127.jpg&imgrefurl=https%3A%2F%2Fwww.veranda.com%2Ftravel%2Fg36674338%2Fbeautiful-mountains%2F&docid=x1WPyYGGK27jdM&tbnid=sGBWR1ZYmMcpuM&vet=12ahUKEwjZ4_LIsfeWAxUWRmwGHbTkGyoQnPAOegQIRBAA..i&w=2145&h=1398&hcb=2&ved=2ahUKEwjZ4_LIsfeWAxUWRmwGHbTkGyoQnPAOegQIRBAA',
                      fit: BoxFit.cover,
                    ),
                    stretchModes: [
                      StretchMode.fadeTitle, // fades out the title
                      StretchMode.blurBackground, // blur out the background
                      StretchMode.zoomBackground, // zoom the background
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.green,
                        ),
                        height: 50,
                        child: Text('item number: $index'),
                      ),
                    );
                  }, childCount: 120),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
