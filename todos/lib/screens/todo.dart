// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todos/apis/todo.dart';
import 'package:todos/components/todo_item.dart';

class TodoLists extends StatefulWidget {
  const TodoLists({super.key});

  @override
  State<TodoLists> createState() => _TodoListsState();
}

class _TodoListsState extends State<TodoLists> {
  List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    // futureBuilder
    return FutureBuilder(
      future: TodoApi().getTodos(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No data', style: TextStyle(fontSize: 24)));
          }

          // update only when data changes
          if (todos.length != snapshot.data!.length) {
            todos = snapshot.data!;
          }

          todos.sort((a, b) => a.id.compareTo(b.id));
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];

              return TodoItem(
                title: todo.title,
                description: todo.description,
                onToggle: (val) {
                  TodoApi().toggleTodo(todo.id, val!);
                },
                onDelete: () async {
                  await TodoApi().deleteTodo(todo.id);
                },
                completed: todo.completed,
              );
            },
          );
        }

        return Text('No data');
      }
    );
  }
}