import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Todo {
  final int id;
  final String title;
  final String description;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': completed,
  };
}

class TodoApi {
  http.Client client = http.Client();
  final String baseUrl = 'http://185.84.160.43:3001';

  final _storage = FlutterSecureStorage();
  
  Future<List<Todo>> getTodos () async {
    String cookie = await _storage.read(key: 'cookie') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/todos'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': cookie,
      }
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Todo> todos = body.map((dynamic item) => Todo.fromJson(item)).toList();
      return todos;
    }

    return [];
  }

  Future<Todo?> createTodo (String title, String description) async {
    String cookie = await _storage.read(key: 'cookie') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/todos'), 
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': cookie,
      }
    );
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<Todo?> updateTodo (int id, String title, String description, bool completed) async {
    String cookie = await _storage.read(key: 'cookie') ?? '';
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$id'), 
      body: jsonEncode({
        'title': title,
        'description': description,
        'completed': completed,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': cookie,
      }
    );
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<bool> deleteTodo (int id) async {
    String cookie = await _storage.read(key: 'cookie') ?? '';
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'), 
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': cookie,
      }
    );
    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<Todo?> toggleTodo (int id, bool completed) async {
    String cookie = await _storage.read(key: 'cookie') ?? '';
    final response = await http.patch(
      Uri.parse('$baseUrl/todos/$id'), 
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': cookie,
      },
      body: jsonEncode({
        'completed': completed,
      })
    );
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    }

    return null;
  }
}
