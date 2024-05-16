import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text('Login', style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              _buildInputField('Nom'),
              const SizedBox(height: 8),
              _buildInputField('Prénom'),
              const SizedBox(height: 8),
              _buildInputField('Pseudo'),
              const SizedBox(height: 8),
              _buildInputField('Email'),
              const SizedBox(height: 8),
              _buildPasswordField('Password'),
              const SizedBox(height: 8),
              _buildPasswordField('Confirm Password'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigation vers l'écran de connexion
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hintText) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField(String hintText) {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}