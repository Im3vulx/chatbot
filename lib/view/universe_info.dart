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
        title: Text('${_universeData?['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUniverseData,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CharacterScreen(universeId: widget.universeId);
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateUniverseName,
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
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '',
                      ),
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    Text('${_universeData?['description']}'),
                    const SizedBox(height: 20),
                    Image.network(
                      "https://mds.sprw.dev/image_data/${_universeData?['image']}",
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
