import 'package:flutter/material.dart';

class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({Key? key}) : super(key: key);

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _characters = [
    {'name': 'Rick Sanchez', 'status': 'Alive'},
    {'name': 'Morty Smith', 'status': 'Alive'},
    {'name': 'Summer Smith', 'status': 'Alive'},
    {'name': 'Jerry Smith', 'status': 'Alive'},
    {'name': 'Beth Smith', 'status': 'Alive'},
    {'name': 'Jessica', 'status': 'Alive'},
  ];

  late List<Map<String, String>> _filteredCharacters;

  @override
  void initState() {
    super.initState();
    _filteredCharacters = _characters;
    _searchController.addListener(_filterCharacters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCharacters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCharacters = _characters
          .where((char) =>
              char['name']!.toLowerCase().contains(query) ||
              char['status']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar personaje...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        // Characters List
        Expanded(
          child: _filteredCharacters.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron personajes',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _filteredCharacters.length,
                  itemBuilder: (context, index) {
                    final character = _filteredCharacters[index];
                    return _CharacterCard(
                      name: character['name']!,
                      status: character['status']!,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final String name;
  final String status;

  const _CharacterCard({
    required this.name,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isAlive = status == 'Alive';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAlive ? Colors.green : Colors.red,
          child: Icon(
            isAlive ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(status),
        trailing: Icon(
          Icons.favorite_border,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Más detalles de $name'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
