import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/todo_cubit.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: SafeArea(
          child: Center(
        child: TextInput(),
      )),
    );
  }
}

class TextInput extends StatefulWidget {
  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  TextEditingController controller = new TextEditingController();
  FocusNode focusNode = new FocusNode();

  void onInputSubmit() {
    if (controller.text.length != 0) {
      context.read<TodoCubit>().add(Todo(controller.text));
      controller.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 32, right: 32),
              child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  onSubmitted: (_) => onInputSubmit(),
                  decoration: InputDecoration(
                      labelText: 'Enter New To-Do',
                      prefixIcon: Icon(Icons.check)))),
          Padding(
            child: ElevatedButton(
              onPressed: () => onInputSubmit(),
              child: Text('Add'),
            ),
            padding: EdgeInsets.only(top: 16),
          )
        ]);
  }
}
