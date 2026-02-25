import 'package:flutter/material.dart';
import 'local_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool validateForm() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void handleLogin() async {

    if (!validateForm()) {
      showMessage("Please fill all fields.");
      return;
    }

    bool isAuthenticated =
        await LocalStorageService.authenticateUser(
          emailController.text,
          passwordController.text,
        );

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showMessage("Incorrect email or password.");
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Message"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: handleLogin,
              child: const Text("Login"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: const Text("Don't have an account? Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}