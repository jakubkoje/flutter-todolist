import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_cubit.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Add To-Do',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
      ),
      body: SafeArea(
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Center(
              child: TextInput(),
            )),
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

  void onInputSubmit() async {
    if (controller.text.length != 0) {
      await context.read<TodoCubit>().add(controller.text, context);
      controller.clear();
      Beamer.of(context).beamToNamed('/');
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
                fillColor: Colors.white,
              ),
            ),
          ),
          Padding(
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: 24, bottom: 24, left: 40, right: 40))),
              onPressed: () => onInputSubmit(),
              child: Text('Add'),
            ),
            padding: EdgeInsets.only(top: 16),
          )
        ]);
  }
}
