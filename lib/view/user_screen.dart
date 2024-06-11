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
  List<Map<String, dynamic>> _filteredUserInfo = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllUserInfo();
    _searchController.addListener(_filterUsers);
  }

  Future<void> _loadAllUserInfo() async {
    final allUserInfo = await _apiService.getAllUsers();
    setState(() {
      _allUserInfo = allUserInfo;
      _filteredUserInfo = allUserInfo;
    });
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUserInfo = _allUserInfo.where((user) {
        return user['username'].toLowerCase().contains(query) ||
               user['email'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        titleTextStyle: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Rechercher...',
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
                    color: Color(0xFFE8E8E8),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _filteredUserInfo.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredUserInfo.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUser(
                                  userId: _filteredUserInfo[index]['id'].toString(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: const Color(0xFF137C8B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(
                                  _filteredUserInfo[index]['username'][0].toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(
                                _filteredUserInfo[index]['username'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(_filteredUserInfo[index]['email'],
                                  style: const TextStyle(color: Colors.white)),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
