import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_styles.dart';
import 'local_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showMessage("Please fill all fields.");
      return;
    }

    bool isAuthenticated = await LocalStorageService.authenticateUser(
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Language Dropdown
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("English(UK)", style: GoogleFonts.inter(fontSize: 12)),
                      const Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const MoviItLogo(size: 80),
              const SizedBox(height: 20),
              Text("Movies, Maza, Masti", style: AppStyles.brandSlogan),
              const SizedBox(height: 60),
              TextField(
                controller: emailController,
                decoration: AppStyles.inputDecoration("Email"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: AppStyles.inputDecoration("Password"),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: handleLogin,
                  child: Text("Login", style: AppStyles.buttonText.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                   // Placeholder for forgot password
                },
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.inter(color: AppStyles.primaryBlue, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.successGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Text("Sign Up", style: AppStyles.buttonText),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
