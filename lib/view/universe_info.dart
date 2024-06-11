import 'package:flutter/material.dart';
import 'package:chatbot/service/universe_service.dart';
import 'package:chatbot/view/character_screen.dart';

class UniverseInfo extends StatefulWidget {
  final String universeId;
  const UniverseInfo({super.key, required this.universeId});

  @override
  State<UniverseInfo> createState() => _UniverseInfoState();
}

class _UniverseInfoState extends State<UniverseInfo> {
  final UniverseService _apiUniverseService = UniverseService();
  final TextEditingController _nameController = TextEditingController();
  Map<String, dynamic>? _universeData;

  @override
  void initState() {
    super.initState();
    _loadUniverseData();
  }

  Future<void> _loadUniverseData() async {
    final universeData =
        await _apiUniverseService.getUniverseData(widget.universeId);
    setState(() {
      _universeData = universeData;
      _nameController.text = _universeData?['name'] ?? '';
    });
  }

  void _updateUniverseName() async {
    final newName = _nameController.text;
    print('New name: $newName');
    final response =
        await _apiUniverseService.updateUniverse(widget.universeId, newName);
    if (response.success) {
      _loadUniverseData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_universeData?['name'] ?? 'Loading...'),
        titleTextStyle: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadUniverseData,
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CharacterScreen(universeId: widget.universeId);
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: _updateUniverseName,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF709CA7),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Nom de l\'univers',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _universeData?['description'] ?? 'Aucune description disponible',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          "https://mds.sprw.dev/image_data/${_universeData?['image']}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 60.0, color: Colors.white),
                        ),
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
