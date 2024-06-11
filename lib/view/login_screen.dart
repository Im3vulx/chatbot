import 'package:flutter/material.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/home_screen.dart';
import 'package:chatbot/view/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthentificationService _authentificationService =
      AuthentificationService();
  String? _errorMessage;

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await _authentificationService.login(username, password);

    if (response.success) {
      if (response.token != null) {
        await _authentificationService.saveToken(response.token!);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = response.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
        titleTextStyle: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              elevation: MaterialStateProperty.all<double>(0),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
            child: const Text('Sign up',
                style: TextStyle(color: Color(0xFF137C8B))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Nom d\'utilisateur',
                  hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                  ),
                )),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                filled: true,
                fillColor: const Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                ),
              ),
              obscureText: true,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF137C8B)),
                elevation: MaterialStateProperty.all<double>(0),
                shadowColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF137C8B)),
              ),
              onPressed: _login,
              child:
                  const Text('Log in', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
