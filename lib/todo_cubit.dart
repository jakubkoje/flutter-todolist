import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  Future<void> fetchTodos() async {
    var todosData = await FirebaseFirestore.instance.collection('todos').get();
    List<Todo> todos = [];
    todosData.docs.forEach((element) {
      var data = element.data();
      data.putIfAbsent('id', () => element.id);
      todos.add(Todo.fromJson(data));
    });
    emit(todos);
  }

  Future<void> add(String todoText) async {
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
  }

  void remove(Todo todo) {
    FirebaseFirestore.instance.collection('todos').doc(todo.id).delete();

    List<Todo> _state = [...state.where((t) => t.id != todo.id)];
    emit(_state);
  }

  void check(Todo todo) {
    FirebaseFirestore.instance
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
  }
}
