import 'package:chatbot/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/service/character_service.dart';
import 'package:chatbot/service/conversation_service.dart';
import 'package:chatbot/view/message_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationService _apiConversationService = ConversationService();
  final CharacterService _apiCharactereService = CharacterService();
  List<Map<String, dynamic>> _allConversation = [];

  String? selectedUniverse;
  String? selectedCharacter;
  List<Map<String, dynamic>> universes = [];
  List<Map<String, dynamic>> characters = [];

  @override
  void initState() {
    super.initState();
    _loadAllConversation();
    _loadAllUniverse();
  }

  Future<void> _loadAllConversation() async {
    final allConversation = await _apiConversationService.getAllConversationInfo();
    setState(() {
      _allConversation = allConversation;
    });
  }

  Future<void> _loadAllUniverse() async {
    final allUniverse = await _apiConversationService.getAllUniverses();
    setState(() {
      universes = allUniverse;
    });
  }

  Future<void> _loadCharactersForUniverse(String universeId) async {
    final charactersInUniverse =
        await _apiConversationService.getCharactersByUniverse(universeId);
    setState(() {
      characters = charactersInUniverse;
      selectedCharacter = null;
    });
  }

  Future<void> _createConversation() async {
    if (selectedCharacter != null) {
      await _apiConversationService.addConversation(selectedUniverse!, selectedCharacter!);
      await _loadAllConversation();
    }
  }

  Future<Map<String, dynamic>> _getCharacterById(String charactereId) async {
    return await _apiCharactereService.getCharacters(charactereId);
  }

  Future<void> _deleteConversation(String conversationId) async {
    await _apiConversationService.deleteConversation(conversationId);
    await _loadAllConversation();
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
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
        title: const Text('Conversation List'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllConversation,
        child: ListView.builder(
          itemCount: _allConversation.length,
          itemBuilder: (context, index) {
            final conversation = _allConversation[index];
            return Dismissible(
              key: Key(conversation['id'].toString()),
              onDismissed: (direction) {
                _deleteConversation(conversation['id'].toString());
              },
              background: Stack(
                children: <Widget>[
                  Container(color: Colors.red),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future:
                    _getCharacterById(conversation['character_id'].toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  } else if (snapshot.hasError) {
                    return const ListTile(
                      title: Text('Error loading character'),
                    );
                  } else {
                    final character = snapshot.data ?? {};
                    return ListTile(
                      leading: character['image'] != null
                          ? Image.network(
                              'https://mds.sprw.dev/image_data/${character['image']}',
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            )
                          : const Icon(Icons.person),
                      title: Text(character['name'] ?? 'Unknown'),
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessageScreen(conversationId: conversation['id'].toString(), characterName: character['name'].toString(), characterImage: character['image'].toString())),
                    )
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Créer une conversation'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: selectedUniverse,
                          hint: const Text('Sélectionnez un univers'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUniverse = newValue;
                            });
                            if (newValue != null) {
                              _loadCharactersForUniverse(newValue);
                            }
                          },
                          items: universes
                              .map((e) => DropdownMenuItem<String>(
                                    value: e['id'].toString(),
                                    child: Text(e['name']),
                                  ))
                              .toList(),
                        ),
                        if (selectedUniverse != null)
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _apiConversationService
                                .getCharactersByUniverse(selectedUniverse!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Erreur de chargement');
                              } else {
                                final characters = snapshot.data ?? [];
                                return DropdownButton<String>(
                                  value: selectedCharacter,
                                  hint:
                                      const Text('Sélectionnez un personnage'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCharacter = newValue;
                                    });
                                  },
                                  items: characters
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e['id'].toString(),
                                            child: Text(e['name']),
                                          ))
                                      .toList(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          _createConversation();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Créer'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}