import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/add_todo/models/todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  Future<void> fetchTodos(BuildContext context) async {
    try {
      var collection =
          await FirebaseFirestore.instance.collection('todos').get();
      List<Todo> _todos = [];
      collection.docs.forEach((element) {
        var data = element.data();
        data.putIfAbsent('id', () => element.id);
        _todos.add(Todo.fromJson(data));
      });
      emit(_todos);
    } catch (err) {
      SnackBar snackBar = SnackBar(content: Text('Failed to fetch todos.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> add(String todoText, BuildContext context) async {
    try {
      var collection = FirebaseFirestore.instance.collection('todos');
      Map<String, dynamic> data = {
        'todoText': todoText,
        'checked': false,
        'createdAt': Timestamp.now()
      };
      var ref = await collection.add(data);
      data.putIfAbsent('id', () => ref.id);
      List<Todo> _state = [...state, Todo.fromJson(data)];
      emit(_state);
    } catch (err) {
      SnackBar snackBar = SnackBar(content: Text('Failed to add todo.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> remove(Todo todo, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(todo.id)
          .delete();
      List<Todo> _state = [...state.where((t) => t.id != todo.id)];
      emit(_state);
    } catch (err) {
      SnackBar snackBar = SnackBar(content: Text('Failed to remove todo.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> check(Todo todo, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(todo.id)
          .update({'checked': !todo.checked});

      List<Todo> _state = [
        ...state.map((t) {
          if (t.id == todo.id) {
            t.checked = !t.checked;
          }
          return t;
        })
      ];
      emit(_state);
    } catch (err) {
      SnackBar snackBar = SnackBar(content: Text('Failed to check todo.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
