import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_v3/second.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final String _baseUrl = "https://jsonplaceholder.typicode.com";
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  _fetchTodos() async {
    final response = await http.get(Uri.parse("$_baseUrl/todos"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        _todos = data.map((rawTodo) => Todo.fromJson(rawTodo)).toList();
      });
    } else {
      throw Exception("Failed to load todos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: [
          ElevatedButton(onPressed: navigateToSecond, child: Text("data"))
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text("Completed: ${todo.completed}"),
          );
        },
      ),
    );
  }

  void navigateToSecond() {
    final res = MaterialPageRoute(builder: (context) => Second());
    Navigator.push(context, res);
  }
}

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      completed: json["completed"],
    );
  }
}
