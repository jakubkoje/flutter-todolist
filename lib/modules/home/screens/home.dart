import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/add_todo/bloc/todo_cubit.dart';
import 'package:todo_app/modules/home/widgets/todolist.dart';

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
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                child: SizedBox(
                    height: 92,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          DateWidget(false),
                          DateWidget(true),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false),
                          DateWidget(false)
                        ]))),
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

class DateWidget extends StatefulWidget {
  final bool today;
  const DateWidget(this.today);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(4),
        child: Card(
            elevation: 5,
            color: widget.today ? Color(0xff3E4685) : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Container(
              padding:
                  EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.today ? Colors.white : Color(0xff3E4685)),
                  ),
                  Text(
                    'PON',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.today ? Colors.grey.shade400 : Colors.grey),
                  )
                ],
              ),
            )));
  }
}
