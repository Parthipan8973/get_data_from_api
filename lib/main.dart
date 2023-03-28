import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_data_from_api/todo.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Todo> todos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(todos[index].title ?? 'no data'),
                      leading: Icon(Icons.add),
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: todos.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            List<Todo> data = await getTodos();
            setState(() {
              todos = data;
            });
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Todo>> getTodos() async {
    String url = 'https://jsonplaceholder.typicode.com/todos/';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('No data');
    }
    String responseBody = response.body;
    List responsemap = jsonDecode(responseBody);
    todos = responsemap.map((e) {
      return Todo(e['userId'], e['id'], e['title'], e['completed']);
    }).toList();
    // print(responseBody);
    return todos;
  }
}
