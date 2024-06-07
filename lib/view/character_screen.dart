import 'package:flutter/material.dart';
import 'package:chatbot/service/character_service.dart';
import 'package:chatbot/view/show_character.dart';

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
        title: const Text('Liste des Personnages'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllCharacters,
        child: Center(
          child: _allCharacterInfo.isEmpty
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _allCharacterInfo.length,
                  itemBuilder: (context, index) {
                    return buildCharacterCard(context, _allCharacterInfo[index], widget.universeId);
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
                title: const Text('Ajouter un Personnage'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Entrez le nom du personnage'),
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
                      _addCharacter();
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

  Widget buildCharacterCard(BuildContext context, Map<String, dynamic> characterInfo, String universeId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterShow(
              universeId: universeId,
              characterId: characterInfo['id'].toString(),
            ),
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
                'https://mds.sprw.dev/image_data/${characterInfo['image']}',
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
                    characterInfo['name'] ?? 'Personnage inconnu',
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
