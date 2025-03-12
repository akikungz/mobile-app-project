import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
  };

  @override
  String toString() {
    return 'User{id: $id, email: $email}';
  }
}

class UserApi {
  http.Client client = http.Client();
  final String baseUrl = 'http://185.84.160.43:3001';

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<User?> me () async {
    String cookie = await _storage.read(key: 'cookie') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    return null;
  }

  Future<User?> signIn (String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/sign-in'), 
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    );
    if (response.statusCode == 200) {
      await _storage.write(
        key: 'cookie', 
        value: response.headers['set-cookie'] ?? ''
      );

      String cookie = await _storage.read(key: 'cookie') ?? '';
      print('Cookie: $cookie');
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    return null;
  }

  Future<User?> signUp (String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/sign-up'), 
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    return null;
  }
}