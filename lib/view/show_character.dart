import 'package:chatbot/service/character_service.dart';
import 'package:flutter/material.dart';

class CharacterShow extends StatefulWidget {
  const CharacterShow({
    super.key,
    required this.universeId,
    required this.characterId,
  });

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
      widget.universeId,
      widget.characterId,
    );
    setState(() {
      _characterData = characterData;
      _nameController.text = _characterData?['name'] ?? '';
    });
  }

  void _updateCharacter() async {
    final response = await _apiCharacterService.updateCharacter(
      widget.universeId,
      widget.characterId,
    );
    if (response.success) {
      _loadCharacterData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _characterData?['name'] ?? 'Character Name',
          style: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadCharacterData,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: _updateCharacter,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF709CA7),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _characterData?['description'] ?? 'Character Description',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      if (_characterData != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            "https://mds.sprw.dev/image_data/${_characterData?['image']}",
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
