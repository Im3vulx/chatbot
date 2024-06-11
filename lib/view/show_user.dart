import 'package:flutter/material.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/user_screen.dart';

class ShowUser extends StatefulWidget {
  const ShowUser({super.key, required this.userId});
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

  Future<void> _loadUserInfo() async {
    final userInfo = await _apiService.getUserInfoById(widget.userId);
    setState(() {
      _usernameController.text = userInfo['username'];
      _emailController.text = userInfo['email'];
      _firstnameController.text = userInfo['firstname'];
      _lastnameController.text = userInfo['lastname'];
    });
  }

  Future<void> _updateUser() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final firstname = _firstnameController.text;
    final lastname = _lastnameController.text;
    await _apiService.updateUserInfo(username, email, firstname, lastname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserScreen()),
            );
          },
        ),
        title: const Text('Edit User'),
        titleTextStyle: const TextStyle(
          color: Color(0xFF344D59),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFF709CA7),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(
                      controller: _usernameController,
                      label: '',
                      hintText: 'Enter your username',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _emailController,
                      label: '',
                      hintText: 'Enter your email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _firstnameController,
                      label: '',
                      hintText: 'Enter your firstname',
                      icon: Icons.account_circle,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _lastnameController,
                      label: '',
                      hintText: 'Enter your lastname',
                      icon: Icons.account_circle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF137C8B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onPressed: _updateUser,
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        prefixIcon: Icon(icon, color: const Color(0xFF137C8B)),
        prefix: Text(label), // Label à l'intérieur du champ de saisie
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFF137C8B),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
