import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todos/apis/user.dart';
import 'package:todos/screens/add_todo.dart';
import 'package:todos/screens/signin.dart';
import 'package:todos/screens/signup.dart';
import 'package:todos/screens/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  @override
  Widget build(BuildContext context) {
    // futureBuilder
    return FutureBuilder<User?>(
      future: UserApi().me(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Todos'),
              actions: [
                Text(snapshot.data!.email),
                IconButton(
                  onPressed: () {
                    setState(() {});
                  }, 
                  icon: Icon(Icons.refresh)
                ),
                IconButton(
                  onPressed: () async {
                    await _storage.delete(key: 'cookie');
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen())
                    );
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: TodoLists(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddTodo())
                );
              },
              child: Icon(Icons.add),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Todos'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome to Todos', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SigninScreen())
                        );
                      },
                      label: Text('Sign in'),
                      icon: Icon(Icons.person),
                    ),
                    SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignupScreen())
                        );
                      },
                      label: Text('Sign up'),
                      icon: Icon(Icons.person_add),
                    ),
                  ],
                )
              ],
            )
          ),
        );
      },
    );
  }
}
