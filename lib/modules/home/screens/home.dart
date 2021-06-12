import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_cubit.dart';
import 'package:todo_app/modules/add_todo/models/todo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().fetchTodos(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: 72,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                  onPressed: () => Beamer.of(context).beamToNamed('/add'),
                  icon: Icon(
                    Icons.add_circle_outline,
                  )))
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 16, bottom: 16),
                child: Text(
                  'What\'s up, Jakub!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text('TODAY\'S TODOS',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))),
            Expanded(child: TodoListWidget())
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Made with love️ by Jakub',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 16),
              child: Text(
                'Nothing here, yet',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: todo.checked,
                                shape: CircleBorder(),
                                onChanged: (bool? value) async {
                                  await context
                                      .read<TodoCubit>()
                                      .check(todo, context);
                                },
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      todo.checked
                                          ? Text(todo.todoText,
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 16))
                                          : Text(todo.todoText,
                                              style: TextStyle(fontSize: 16)),
                                      Container(
                                          margin: EdgeInsets.only(top: 4),
                                          child: Text(
                                              '${todo.createdAt.day}. ${todo.createdAt.month}. ${todo.createdAt.year}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey))),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )),
                );
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
