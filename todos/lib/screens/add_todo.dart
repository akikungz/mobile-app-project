// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:todos/apis/todo.dart';
import 'package:todos/screens/home.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              controller: descriptionController,
            ),
            SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                // Add todo
                Todo? data = await TodoApi().createTodo(
                  titleController.text, 
                  descriptionController.text
                );

                print(data);
                if (data != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen())
                  );
                  return;
                }

                // Show error
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to add todo'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      )
                    ],
                  );
                });
              }, 
              label: Text('Add Todo'),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
