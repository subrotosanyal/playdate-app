import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/logger.dart';  // Import the logger

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  Future<void> signup(String email, String password) async {
    AppLogger().logger.info('Signup attempt for user: $email');
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5001/api/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        AppLogger().logger.info('Signup successful for user: $email');
        setState(() {
          message = 'Signup successful!';
        });
      } else {
        AppLogger().logger.warning('Signup failed for user: $email - ${response.body}');
        setState(() {
          message = 'Signup failed: ${jsonDecode(response.body)['msg']}';
        });
      }
    } catch (error) {
      AppLogger().logger.severe('Error during signup: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
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
                signup(emailController.text, passwordController.text);
              },
              child: Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Already have an account? Login"),
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
