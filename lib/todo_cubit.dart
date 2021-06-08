import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  late String todoText;
  late String id;
  late bool checked;
  late DateTime createdAt;
  Todo(String todoText) {
    this.todoText = todoText;
    this.id = uuid.v4();
    this.checked = false;
    this.createdAt = DateTime.now();
  }
}

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void add(Todo todo) {
    emit([...state, todo]);
  }

  void remove(Todo todo) {
    emit([...state.where((t) => t.id != todo.id)]);
  }

  void check(Todo todo) {
    emit([
      ...state.map((t) {
        if (t.id == todo.id) {
          t.checked = !t.checked;
        }
        return t;
      })
    ]);
  }
}
