import 'package:flutter/material.dart';
import 'package:todos/apis/user.dart';
import 'package:todos/screens/signin.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Icon(Icons.person_add, size: 100),
              Text('Sign up Screen', style: TextStyle(fontSize: 24)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
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

                  if (passwordController.text != confirmPasswordController.text) {
                    print('Passwords do not match');

                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Passwords do not match'),
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

                  Future<User?> user = UserApi().signUp(
                    emailController.text,
                    passwordController.text
                  );

                  user.then((value) {
                    if (value != null) {
                      print('User: $value');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SigninScreen())
                      );
                    } else {
                      print('Failed to sign up');

                      // ignore: use_build_context_synchronously
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to sign up'),
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
                label: Text('Sign up', style: TextStyle(fontSize: 20)),
                icon: Icon(Icons.person_add),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SigninScreen())
                      );
                    },
                    child: Text('Sign in'),
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
