import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  String todoText = '';
  String id = '';
  bool checked = false;
  DateTime createdAt = DateTime.now();

  Todo(String todoText) {
    this.todoText = todoText;
    this.id = uuid.v4();
    this.checked = false;
    this.createdAt = DateTime.now();
  }

  Todo.fromJson(Map<String, dynamic> json) {
    debugPrint(json['todoText']);
    this.todoText = json['todoText'];
    this.id = json['id'];
    this.checked = json['checked'] == 'true';
    this.createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() => {
        'todoText': this.todoText,
        'id': this.id,
        'checked': this.checked.toString(),
        'createdAt': this.createdAt.toIso8601String()
      };
}

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void fetchTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todosString = prefs.getString('todos') ?? '';
    if (todosString.length > 0) {
      List<Todo> todos =
          List<Todo>.from(jsonDecode(todosString).map((i) => Todo.fromJson(i)));
      emit(todos);
    }
  }

  void add(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> _state = [...state, todo];
    prefs.setString(
        'todos', jsonEncode(_state.map((e) => e.toJson()).toList()));
    emit(_state);
  }

  void remove(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> _state = [...state.where((t) => t.id != todo.id)];
    prefs.setString(
        'todos', jsonEncode(_state.map((e) => e.toJson()).toList()));
    emit(_state);
  }

  void check(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> _state = [
      ...state.map((t) {
        if (t.id == todo.id) {
          t.checked = !t.checked;
        }
        return t;
      })
    ];
    prefs.setString(
        'todos', jsonEncode(_state.map((e) => e.toJson()).toList()));

    emit(_state);
  }
}
