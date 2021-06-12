import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/config/routes.dart';
import 'package:todo_app/config/theme.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_cubit.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = TodoObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TodoCubit(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: themeData,
          routeInformationParser: BeamerParser(),
          routerDelegate: beamerDelegate,
        ));
  }
}
