import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/todo_cubit.dart';
import 'package:todo_app/todo_observer.dart';

void main() async {
  Bloc.observer = TodoObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TodoCubit(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            navigatorObservers: <NavigatorObserver>[
              FirebaseAnalyticsObserver(analytics: analytics)
            ],
            home: HomePage()));
  }
}
