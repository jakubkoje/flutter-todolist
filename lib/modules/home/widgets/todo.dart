import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_cubit.dart';
import 'package:todo_app/modules/add_todo/models/todo.dart';

class TodoCard extends StatefulWidget {
  final Todo todo;
  final bool test;
  const TodoCard(this.todo, this.test);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: widget.test ? 0 : 5,
      color: widget.test ? Colors.grey.withOpacity(0.1) : Colors.white,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: widget.todo.checked,
              shape: CircleBorder(),
              onChanged: (bool? value) async {
                await context.read<TodoCubit>().check(widget.todo, context);
              },
            ),
            Container(
                margin: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.todo.checked
                        ? Text(widget.todo.todoText,
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 16))
                        : Text(widget.todo.todoText,
                            style: TextStyle(fontSize: 16)),
                    Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                            '${widget.todo.createdAt.day}. ${widget.todo.createdAt.month}. ${widget.todo.createdAt.year}',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey))),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
