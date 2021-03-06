import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:isolate_worker/isolate_tasks/get_todo_task.dart';
import 'package:isolate_worker/worker/worker.dart';

import '../todo_model.dart';

class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  TodoModel todoModel;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var value = 'No data';
    if (loading) {
      value = 'Loading...';
    } else {
      if (todoModel != null) {
        value = todoModel.toString();
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab1'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Get Todo'),
            onPressed: getTodoData,
          ),
          Divider(),
          Text(value)
        ],
      ),
    );
  }

  void getTodoData() async {
    setState(() {
      loading = true;
    });
    final dio = Dio();
    var todoTask = GetTodoTask(dio: dio, id: 1);
    final worker = Worker(poolSize: 2);
    todoModel = (await worker.handle(todoTask)) as TodoModel;

//    todoModel = await compute(handle, todoTask);

    setState(() {
      loading = false;
    });
  }

  static Future<TodoModel> handle(GetTodoTask task) async {
    return task.execute();
  }
}
