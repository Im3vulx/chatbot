import 'package:chatbot/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/view/add_univers.dart';
import 'package:chatbot/view/home_screen.dart';

class UniversScreen extends StatefulWidget {
  const UniversScreen({super.key});

  @override
  State<UniversScreen> createState() => _UniversScreenState();
}

class _UniversScreenState extends State<UniversScreen> {
  final AuthentificationService _apiService = AuthentificationService();
  List<Map<String, dynamic>> _allUniverseInfo = [];

  @override
  void initState() {
    super.initState();
    _loadAllUnivers();
  }

  Future<void> _loadAllUnivers() async {
    final allUniverseInfo = await _apiService.getAllUniverseInfo();
    setState(() {
      _allUniverseInfo = allUniverseInfo;
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
        title: const Text('Universe List'),
      ),
      body: Center(
        child: _allUniverseInfo.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _allUniverseInfo.length,
                itemBuilder: (context, index) {
                  return buildUniverseColumn(_allUniverseInfo[index]);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUniverse()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget buildUniverseColumn(Map<String, dynamic> universeInfo) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    height: 60.0,
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.black),
        right: BorderSide(color: Colors.black),
        bottom: BorderSide(color: Colors.black),
        left: BorderSide(color: Colors.black),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 10.0),
          child: Image.network('https://mds.sprw.dev/image_data/${universeInfo['image']}',
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 60.0,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(universeInfo['name'] ?? 'Universe unknown',style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    ),
  );
}