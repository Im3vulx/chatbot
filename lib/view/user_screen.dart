import 'package:chatbot/view/show_user.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/view/home_screen.dart';
import 'package:chatbot/service/auth_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AuthentificationService _apiService = AuthentificationService();
  List<Map<String, dynamic>> _allUserInfo = [];

  @override
  void initState() {
    super.initState();
    _loadAllUserInfo();
  }

  Future<void> _loadAllUserInfo() async {
    final allUserInfo = await _apiService.getAllUsers();
    setState(() {
      _allUserInfo = allUserInfo;
    });
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
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text('User List'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _allUserInfo.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShowUser(userId: _allUserInfo[index]['id'].toString())));
              },
              child: Card(
                child: ListTile(
                  title: Text(_allUserInfo[index]['username']),
                  subtitle: Text(_allUserInfo[index]['email']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
