import 'package:flutter/material.dart';

class AddUniverse extends StatefulWidget {
  const AddUniverse({super.key});

  @override
  State<AddUniverse> createState() => _AddUniverseState();
}

class _AddUniverseState extends State<AddUniverse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Universe'),
      ),
      body: const Center(
        child: Text('Add Universe'),
        ),
    );
  }
}