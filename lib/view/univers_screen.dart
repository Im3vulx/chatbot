import 'package:flutter/material.dart';
import 'package:chatbot/service/universe_service.dart';
import 'package:chatbot/view/home_screen.dart';
import 'package:chatbot/view/universe_info.dart';

class UniversScreen extends StatefulWidget {
  const UniversScreen({super.key});

  @override
  State<UniversScreen> createState() => _UniversScreenState();
}

class _UniversScreenState extends State<UniversScreen> {
  final UniverseService _apiUniverseService = UniverseService();
  List<Map<String, dynamic>> _allUniverseInfo = [];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllUnivers();
  }

  Future<void> _loadAllUnivers() async {
    final allUniverseInfo = await _apiUniverseService.getAllUniverseInfo();
    setState(() {
      _allUniverseInfo = allUniverseInfo;
    });
  }

  void _addUniverse() async {
    await _apiUniverseService.addUniverse(_textFieldController.text);
    _loadAllUnivers();
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
      body: RefreshIndicator(
        onRefresh: _loadAllUnivers,
        child :Center(
        child: _allUniverseInfo.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _allUniverseInfo.length,
                itemBuilder: (context, index) {
                  return buildUniverseColumn(context, _allUniverseInfo[index]);
                },
              ),
        ),
      ), 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Universe'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: "Enter Universe Name"),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      _addUniverse();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildUniverseColumn(BuildContext context, Map<String, dynamic> universeInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniverseInfo(universeInfo: universeInfo),
          ),
        );
      },
      child: Container(
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
              child: Image.network(
                'https://mds.sprw.dev/image_data/${universeInfo['image']}',
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
                  Text(
                    universeInfo['name'] ?? 'Universe unknown',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}