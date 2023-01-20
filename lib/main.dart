import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import './models/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
            primarySwatch: Colors.lime,
            scaffoldBackgroundColor: Color.fromARGB(255, 35, 98, 100)),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _todoController = TextEditingController();
  static const uuid = Uuid();

  final List<Todo> _todoList = [
    Todo(uuid.v4(), 'Walking the dog'),
    Todo(uuid.v4(), 'Taking out the trash'),
    Todo(uuid.v4(), 'Washing the dishes')
  ];

  void _openModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(color: Colors.black),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'TODO title',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  controller: _todoController,
                  onSubmitted: (_) => _submitTodo(),
                )
              ],
            ),
          );
        });
  }

  void _submitTodo() {
    final enteredTodo = _todoController.text;

    setState(() {
      _todoList.add(Todo(uuid.v1(), enteredTodo));
    });

    _todoController.clear();
    Navigator.of(context).pop();
  }

  void _deleteTodo(String id) {
    setState(() {
      _todoList.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '<AMAZING TODO\'s> ',
          style: TextStyle(fontFamily: 'Huglove', fontSize: 30),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _todoList.isEmpty
                  ? Image.asset('assets/images/banana.png')
                  : ListView.builder(
                      itemCount: _todoList.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              tileColor: Theme.of(context).backgroundColor,
                              title: Text(
                                '${_todoList[index].title}',
                                style: TextStyle(fontFamily: 'Vanilla'),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () =>
                                    _deleteTodo(_todoList[index].id),
                              ),
                            ));
                      },
                    ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _openModal(context), child: Icon(Icons.add)),
    );
  }
}
