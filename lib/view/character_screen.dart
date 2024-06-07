import 'package:chatbot/service/character_service.dart';
import 'package:chatbot/view/show_character.dart';
import 'package:flutter/material.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key, required this.universeId});
  final String universeId;

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final CharacterService _apiCharacterService = CharacterService();
  List<Map<String, dynamic>> _allCharacterInfo = [];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllCharacters();
  }

  Future<void> _loadAllCharacters() async {
    final allCharacterInfo = await _apiCharacterService.getAllCharacterInfo(widget.universeId);
    setState(() {
      _allCharacterInfo = allCharacterInfo;
    });
  }

  Future<void> _addCharacter() async {
    final name = _textFieldController.text;
    final universeId = widget.universeId;
    await _apiCharacterService.addCharacter(name, universeId);
    _loadAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character List'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllCharacters,
        child :Center(
        child: _allCharacterInfo.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _allCharacterInfo.length,
                itemBuilder: (context, index) {
                  return buildUniverseColumn(context, _allCharacterInfo[index], widget.universeId);
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
                title: const Text('Add Character'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: "Enter Character Name"),
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
                      _addCharacter();
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

  Widget buildUniverseColumn(BuildContext context, Map<String, dynamic> characterInfo, String universeId) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CharacterShow(universeId: universeId, characterId: characterInfo['id'].toString()),
          )
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
                'https://mds.sprw.dev/image_data/${characterInfo['image']}',
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
                    characterInfo['name'] ?? 'Character unknown',
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