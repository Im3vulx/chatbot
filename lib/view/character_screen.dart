import 'package:flutter/material.dart';
import 'package:chatbot/service/character_service.dart';
import 'package:chatbot/view/show_character.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({Key? key, required this.universeId}) : super(key: key);
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
        titleTextStyle: const TextStyle(
          color: Color(0xFF344D59),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadAllCharacters,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllCharacters,
        child: ListView.builder(
          itemCount: _allCharacterInfo.length,
          itemBuilder: (context, index) {
            return buildCharacterCard(context, _allCharacterInfo[index], widget.universeId);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF137C8B),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF709CA7),
                title: const Text('Ajouter un Personnage', style: TextStyle(color: Colors.white)),
                content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Entrez le nom du personnage', hintStyle: TextStyle(color: Colors.white)),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      _addCharacter();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
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
      child: Card(
        color: const Color(0xFF709CA7),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  'https://mds.sprw.dev/image_data/${characterInfo['image']}',
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 60.0,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      characterInfo['name'] ?? 'Personnage inconnu',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
