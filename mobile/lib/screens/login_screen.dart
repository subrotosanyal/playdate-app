import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import '../utils/logger.dart';  // Import the logger

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  Future<void> login(String email, String password) async {
    AppLogger().logger.info('Login attempt for user: $email');
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5001/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        AppLogger().logger.info('Login successful for user: $email');
        setState(() {
          message = 'Login successful!';
        });
      } else {
        AppLogger().logger.warning('Login failed for user: $email - ${response.body}');
        setState(() {
          message = 'Login failed: ${jsonDecode(response.body)['msg']}';
        });
      }
    } catch (error) {
      AppLogger().logger.severe('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login(emailController.text, passwordController.text);
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text("Don't have an account? Sign Up"),
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
