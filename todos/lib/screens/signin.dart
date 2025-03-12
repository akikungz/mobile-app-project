import 'package:flutter/material.dart';
import 'package:todos/apis/user.dart';
import 'package:todos/screens/home.dart';
import 'package:todos/screens/signup.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Icon(Icons.person, size: 100),
              Text('Sign in Screen', style: TextStyle(fontSize: 24)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    print('Email and password are required');

                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Email and password are required'),
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
                    return;
                  }

                  print('Email: ${emailController.text}');
                  print('Password: ${passwordController.text}');

                  Future<User?> user = UserApi().signIn(emailController.text, passwordController.text);
                  user.then((value) {
                    if (value != null) {
                      print('User: $value');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen())
                      );
                    } else {
                      print('Invalid email or password');

                      // ignore: use_build_context_synchronously
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Invalid email or password'),
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
                    }
                  });
                }, 
                label: Text('Sign in', style: TextStyle(fontSize: 20)),
                icon: Icon(Icons.person),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignupScreen())
                      );
                    },
                    child: Text('Sign up'),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
