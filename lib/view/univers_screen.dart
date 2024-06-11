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
        titleTextStyle: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UniverseSearchDelegate(_allUniverseInfo),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllUnivers,
        child: Center(
          child: _allUniverseInfo.isEmpty
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _allUniverseInfo.length,
                  itemBuilder: (context, index) {
                    return buildUniverseCard(context, _allUniverseInfo[index]);
                  },
                ),
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
                title: const Text('Ajouter un univers', style: TextStyle(color: Colors.white)),
                content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Entrez le nom de l\'univers', hintStyle: TextStyle(color: Colors.white)),
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
                      _addUniverse();
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

  Widget buildUniverseCard(BuildContext context, Map<String, dynamic> universeInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniverseInfo(universeId: universeInfo['id'].toString()),
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
                  'https://mds.sprw.dev/image_data/${universeInfo['image']}',
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
                      universeInfo['name'] ?? 'Univers inconnu',
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

class UniverseSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> universeList;

  UniverseSearchDelegate(this.universeList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = universeList
        .where((universe) =>
            universe['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return buildUniverseCard(context, results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = universeList
        .where((universe) =>
            universe['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return buildUniverseCard(context, suggestions[index]);
      },
    );
  }

  Widget buildUniverseCard(BuildContext context, Map<String, dynamic> universeInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniverseInfo(universeId: universeInfo['id'].toString()),
          ),
        );
      },
      child: Card(
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
                  'https://mds.sprw.dev/image_data/${universeInfo['image']}',
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
                      universeInfo['name'] ?? 'Univers inconnu',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Description de l\'univers', // Remplacez ceci par la vraie description si disponible
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
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
