import 'package:flutter/material.dart';
import 'package:chatbot/view/conversation_screen.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/login_screen.dart';
import 'package:chatbot/view/user_screen.dart';
import 'package:chatbot/view/univers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthentificationService _apiService = AuthentificationService();
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _apiService.getUserInfo();
    setState(() {
      _userInfo = userInfo;
    });
  }

  void _logout(BuildContext context) async {
    await _apiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        titleTextStyle: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Bonjour ${_userInfo?['username']}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40.0),
            Card(
              color: const Color(0xFF137C8B),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UserScreen()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Utilisateurs', style: TextStyle(fontSize: 18, color: Colors.white)),
                      Icon(Icons.person, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              color: const Color(0xFF137C8B),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UniversScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Univers', style: TextStyle(fontSize: 18, color: Colors.white)),
                      Icon(Icons.public, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              color: const Color(0xFF137C8B),
              elevation: 4,
              child: InkWell(
                onTap: (){ 
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConversationScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Conversations', style: TextStyle(fontSize: 18, color: Colors.white)),
                      Icon(Icons.chat, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
