import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/home.dart';
import 'package:test_app/todo_cubit.dart';
import 'package:test_app/todo_observer.dart';

void main() {
  Bloc.observer = TodoObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TodoCubit(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'To-Do List',
            home: HomePage()));
  }
}
