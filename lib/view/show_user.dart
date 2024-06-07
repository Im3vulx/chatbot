import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/user_screen.dart';
import 'package:flutter/material.dart';

class ShowUser extends StatefulWidget {
  const ShowUser({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final AuthentificationService _apiService = AuthentificationService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load user information using the provided user ID
  Future<void> _loadUserInfo() async {
    // Assuming you have a method in AuthService to get user info by ID
    final userInfo = await _apiService.getUserInfoById(widget.userId);
    setState(() {
      _usernameController.text = userInfo['username'];
      _emailController.text = userInfo['email'];
      _firstnameController.text = userInfo['firstname'];
      _lastnameController.text = userInfo['lastname'];
    });
  }

  // Update the user information
  Future<void> _updateUser() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final firstname = _firstnameController.text;
    final lastname = _lastnameController.text;

    // Update user info using the provided service method
    await _apiService.updateUserInfo(username, email, firstname, lastname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserScreen()));
          },
        ),
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'Firstname'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Lastname'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateUser();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
