import 'package:chatbot/service/character_service.dart';
import 'package:flutter/material.dart';

class CharacterShow extends StatefulWidget {
  const CharacterShow(
      {super.key, required this.universeId, required this.characterId});
  final String universeId;
  final String characterId;

  @override
  State<CharacterShow> createState() => _CharacterShowState();
}

class _CharacterShowState extends State<CharacterShow> {
  final TextEditingController _nameController = TextEditingController();
  final CharacterService _apiCharacterService = CharacterService();
  Map<String, dynamic>? _characterData;

  @override
  void initState() {
    super.initState();
    _loadCharacterData();
  }

  Future<void> _loadCharacterData() async {
    final characterData = await _apiCharacterService.getCharacterData(
        widget.universeId, widget.characterId);
    setState(() {
      _characterData = characterData;
      _nameController.text = _characterData?['name'] ?? '';
    });
  }

  void _updateCharacter() async {
    final response = await _apiCharacterService.updateCharacter(
        widget.universeId, widget.characterId);
    if (response.success) {
      _loadCharacterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_characterData?['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCharacterData,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateCharacter,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text('${_characterData?['description']}'),
                    const SizedBox(height: 20),
                    Image.network(
                      "https://mds.sprw.dev/image_data/${_characterData?['image']}",
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
