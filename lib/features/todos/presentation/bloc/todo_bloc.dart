import 'dart:async';

import 'package:flutter_architecture_poc/core/usecases/usecase.dart';
import 'package:flutter_architecture_poc/features/todos/domain/usecases/create_to_do_use_case.dart';
import 'package:flutter_architecture_poc/features/todos/domain/usecases/delete_to_do_use_case.dart';
import 'package:flutter_architecture_poc/features/todos/domain/usecases/fetch_todo_use_case.dart';
import 'package:flutter_architecture_poc/features/todos/presentation/bloc/todo_event.dart';
import 'package:flutter_architecture_poc/features/todos/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/update_to_do_use_case.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final CreateToDoUseCase createToDoUseCase;
  final DeleteToDoUseCase deleteToDoUseCase;
  final FetchTodoUseCase fetchToDoUseCase;
  final UpdateToDoUseCase updateToDoUseCase;

  TodoBloc({
    required this.createToDoUseCase,
    required this.deleteToDoUseCase,
    required this.fetchToDoUseCase,
    required this.updateToDoUseCase,
  }) : super(TodoInitial()) {
    on<TodoCreate>(_create);
    on<TodoDelete>(_delete);
    on<TodoFetch>(_fetch);
    on<TodoUpdate>(_update);
  }

  FutureOr<void> _create(TodoCreate event, Emitter<TodoState> emit) {}

  FutureOr<void> _delete(TodoDelete event, Emitter<TodoState> emit) {}

  FutureOr<void> _fetch(TodoFetch event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await fetchToDoUseCase(NoParams());
    await result.fold((l) {
      emit(TodoError(message: l.toString()));
    }, (r) {
      emit(TodoList(todos: r));
    });
  }

  FutureOr<void> _update(TodoUpdate event, Emitter<TodoState> emit) {}
}
