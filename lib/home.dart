import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/add_todo.dart';
import 'package:test_app/todo.dart';
import 'package:test_app/todo_cubit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'To-Do List',
          ),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AddTodo())),
                icon: Icon(Icons.add))
          ],
        ),
        body: SafeArea(
          child: TodoListWidget(),
        ));
  }
}

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, List<Todo>>(builder: (context, state) {
      return (context.read<TodoCubit>().state.length != 0
          ? ListView.separated(
              itemCount: context.read<TodoCubit>().state.length,
              itemBuilder: (context, index) {
                Todo todo = context.read<TodoCubit>().state[index];
                return Dismissible(
                    key: Key(todo.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      context.read<TodoCubit>().remove(todo);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(todo.todoText + ' todo dismissed')));
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon((Icons.cancel)),
                      padding: EdgeInsets.only(right: 8),
                      alignment: Alignment.centerRight,
                    ),
                    child: CheckboxListTile(
                      title: todo.checked
                          ? Text(todo.todoText,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough))
                          : Text(todo.todoText),
                      subtitle: Text(
                          '${todo.createdAt.day}. ${todo.createdAt.month}. ${todo.createdAt.year}'),
                      value: todo.checked,
                      onChanged: (bool? value) {
                        context.read<TodoCubit>().check(todo);
                      },
                    ));
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
                    'assets/images/sad-sleepy-emoticon-face-square.svg',
                    color: Colors.grey,
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                ),
                Text(
                  'No Todos...',
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
