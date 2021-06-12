import 'package:beamer/beamer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/modules/add_todo/screens/add_todo.dart';
import 'package:todo_app/modules/home/screens/home.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics();

final beamerDelegate = BeamerDelegate(
    navigatorObservers: <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: analytics)
    ],
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context, state) => BeamPage(
          name: 'Home',
          key: ValueKey('Home'),
          child: HomePage(),
          title: 'Todo App',
          type: BeamPageType.cupertino),
      '/add': (context, state) => BeamPage(
          name: 'AddTodo',
          key: ValueKey('AddTodo'),
          child: AddTodo(),
          title: 'Add Todo',
          type: BeamPageType.cupertino)
    }));
