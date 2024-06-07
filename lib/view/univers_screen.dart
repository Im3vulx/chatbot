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
        title: const Text('Liste des Univers'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllUnivers,
        child: Center(
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
                title: const Text('Ajouter un univers'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Entrez le nom de l\'univers'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addUniverse();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ajouter'),
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
            builder: (context) => UniverseInfo(universeId: universeInfo['id'].toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        height: 100.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    universeInfo['name'] ?? 'Univers inconnu',
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
