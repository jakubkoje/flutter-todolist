import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_cubit.dart';
import 'package:todo_app/modules/add_todo/models/todo.dart';
import 'package:todo_app/modules/home/widgets/todo.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, List<Todo>>(builder: (context, state) {
      return (context.read<TodoCubit>().state.length != 0
          ? ListView.builder(
              itemCount: context.read<TodoCubit>().state.length,
              itemBuilder: (context, index) {
                Todo todo = context.read<TodoCubit>().state[index];
                return Dismissible(
                    key: Key(todo.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      await context.read<TodoCubit>().remove(todo, context);
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(todo.todoText + ' todo dismissed')));
                    },
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 8),
                        child: LayoutBuilder(
                            builder: (context, constraints) =>
                                LongPressDraggable(
                                  feedback: Container(
                                    child: TodoCard(todo, false),
                                    width: constraints.maxWidth,
                                  ),
                                  childWhenDragging: TodoCard(todo, true),
                                  child: TodoCard(todo, false),
                                  delay: Duration(milliseconds: 200),
                                ))));
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
                    'assets/images/emoticon-square-smiling-face-with-closed-eyes.svg',
                    color: Colors.grey,
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                ),
                Text(
                  'No more todos for today!',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ));
    });
  }
}
