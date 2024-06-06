import 'package:flutter/material.dart';
import 'package:chatbot/service/universe_service.dart';

class UniverseInfo extends StatelessWidget {
  final Map<String, dynamic> universeInfo;

  UniverseInfo({super.key, required this.universeInfo});

  final UniverseService _apiUniverseService = UniverseService();
  final TextEditingController _nameController = TextEditingController();
  
  void _updateUniverse() async {
    await _apiUniverseService.updateUniverse(universeInfo['id'].toString(), _nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(universeInfo['name'] ?? 'Universe Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              // vers charactere screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _updateUniverse();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://mds.sprw.dev/image_data/${universeInfo['image']}',
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100.0,
                ),
                height: 200.0,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: '${universeInfo['name']}'),
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              universeInfo['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
