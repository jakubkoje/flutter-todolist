import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/todo_cubit.dart';
import 'package:test_app/todo_observer.dart';

void main() {
  Bloc.observer = TodoObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List'),
        ),
        body: SafeArea(child: HomePage()),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: BlocProvider(
            create: (_) => TodoCubit(),
            child: Column(children: <Widget>[TodoListWidget(), TextInput()])),
        onTap: () {
          FocusScope.of(context).unfocus();
        });
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
    }
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: (_) => onInputSubmit(),
        decoration: InputDecoration(
            labelText: 'Enter New To-Do',
            prefixIcon: Icon(Icons.check),
            suffixIcon: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: onInputSubmit)));
  }
}

class TodoListWidget extends StatefulWidget {
  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, List<Todo>>(builder: (context, state) {
      return Expanded(
          child: (context.read<TodoCubit>().state.length != 0
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
                              content:
                                  Text(todo.todoText + ' todo dismissed')));
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
              : Center(
                  child: Text(
                    'No todos',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                )));
    });
  }
}
