import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  String todoText = '';
  String id = '';
  bool checked = false;
  DateTime createdAt = DateTime.now();

  Todo(String todoText) {
    this.todoText = todoText;
    // this.id = uuid.v4();
    this.checked = false;
    this.createdAt = DateTime.now();
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      json['todoText'] as String,
    )
      ..id = json['id'] as String
      ..checked = json['checked'] as bool
      ..createdAt = DateTime.fromMicrosecondsSinceEpoch(
          json['createdAt'].microsecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() => {
        'todoText': this.todoText,
        // 'id': instance.id,
        'checked': this.checked,
        'createdAt': this.createdAt.toIso8601String(),
      };
}
