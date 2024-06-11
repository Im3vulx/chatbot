import 'package:flutter/material.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/home_screen.dart';
import 'package:chatbot/view/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final AuthentificationService _authentificationService = AuthentificationService();
  String? _errorMessage;

  void _register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;
    final String firstname = _firstnameController.text;
    final String lastname = _lastnameController.text;

    final response = await _authentificationService.register(username, password, email, firstname, lastname);

    if (response.success) {
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
        title: const Text('Sign up'),
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
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Login', style: TextStyle(color: Color(0xFF137C8B))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_errorMessage != null)
              Container(
                alignment: Alignment.center,
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur',
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
                  ),),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe',
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
                  ),),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration:  InputDecoration(labelText: 'Email',
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
                  ),),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstnameController,
              decoration: InputDecoration(labelText: 'Prénom',
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
                  ),),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastnameController,
              decoration:  InputDecoration(labelText: 'Nom',
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
                  ),),
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
              onPressed: _register,
              child: const Text('Sign up', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
