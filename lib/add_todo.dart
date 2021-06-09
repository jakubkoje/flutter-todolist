import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        title: Text('Add To-Do'),
      ),
      body: SafeArea(
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: TextInput(),
        ),
        onTap: () => FocusScope.of(context).unfocus(),
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
    } else {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16, bottom: 128),
              child: SvgPicture.asset(
                'assets/images/to-do-list.svg',
                width: 256,
              )),
          Padding(
            padding: EdgeInsets.only(left: 32, right: 32),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onSubmitted: (_) => onInputSubmit(),
              decoration: InputDecoration(
                labelText: 'Enter New To-Do',
                prefixIcon: Icon(Icons.check),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    borderSide: BorderSide(color: Colors.blue.shade500)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    borderSide: BorderSide(color: Colors.blue.shade100)),
                filled: true,
                fillColor: Colors.blue[50],
              ),
            ),
          ),
          Padding(
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: 20, bottom: 20, left: 40, right: 40))),
              onPressed: () => onInputSubmit(),
              child: Text('Add'),
            ),
            padding: EdgeInsets.only(top: 16),
          )
        ]);
  }
}
