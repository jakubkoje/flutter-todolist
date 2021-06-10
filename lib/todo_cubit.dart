import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void fetchTodos() async {
    var todosData = await FirebaseFirestore.instance.collection('todos').get();
    List<Todo> todos = [];
    todosData.docs.forEach((element) {
      var data = element.data();
      data.putIfAbsent('id', () => element.id);
      debugPrint(element.id.toString());
      todos.add(Todo.fromJson(data));
      debugPrint(todos.toString());
    });
    emit(todos);
  }

  void add(String todoText) async {
    var collection = FirebaseFirestore.instance.collection('todos');
    Map<String, dynamic> data = {
      'todoText': todoText,
      'checked': false,
      'createdAt': Timestamp.now()
    };
    var ref = await collection.add(data);
    data.putIfAbsent('id', () => ref.id);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> _state = [...state, Todo.fromJson(data)];
    // prefs.setString(
    //     'todos', jsonEncode(_state.map((e) => e.toJson()).toList()));
    emit(_state);
  }

  void remove(Todo todo) async {
    await FirebaseFirestore.instance.collection('todos').doc(todo.id).delete();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> _state = [...state.where((t) => t.id != todo.id)];
    // prefs.setString(
    //     'todos', jsonEncode(_state.map((e) => e.toJson()).toList()));
    emit(_state);
  }

  void check(Todo todo) async {
    FirebaseFirestore.instance
        .collection('todos')
        .doc(todo.id)
        .update({'checked': !todo.checked});

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> _state = [
      ...state.map((t) {
        if (t.id == todo.id) {
          t.checked = !t.checked;
        }
        return t;
      })
    ];
    // prefs.setString(
    //     'todos', jsonEncode(_state.map((e) => e.toJson()).toList()));

    emit(_state);
  }
}
