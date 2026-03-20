import 'package:flutter/material.dart';
import '../services/favorites_manager.dart';

class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({Key? key}) : super(key: key);

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  final FavoritesManager _favoritesManager = FavoritesManager();

  final List<Map<String, String>> _characters = [
    {'name': 'Rick Sanchez', 'status': 'Alive', 'species': 'Human', 'emoji': '👨‍🔬'},
    {'name': 'Morty Smith', 'status': 'Alive', 'species': 'Human', 'emoji': '👦'},
    {'name': 'Summer Smith', 'status': 'Alive', 'species': 'Human', 'emoji': '👧'},
    {'name': 'Jerry Smith', 'status': 'Alive', 'species': 'Human', 'emoji': '👨'},
    {'name': 'Beth Smith', 'status': 'Alive', 'species': 'Human', 'emoji': '👩'},
    {'name': 'Jessica', 'status': 'Alive', 'species': 'Human', 'emoji': '👩‍🦰'},
    {'name': 'Squanchy', 'status': 'Alive', 'species': 'Squanch', 'emoji': '🐯'},
    {'name': 'Birdperson', 'status': 'Dead', 'species': 'Birdperson', 'emoji': '🦅'},
  ];

  late List<Map<String, String>> _filteredCharacters;

  @override
  void initState() {
    super.initState();
    _filteredCharacters = _characters;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _searchController.addListener(_filterCharacters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterCharacters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCharacters = _characters;
      } else {
        _filteredCharacters = _characters
            .where((char) =>
                char['name']!.toLowerCase().contains(query) ||
                char['status']!.toLowerCase().contains(query) ||
                char['species']!.toLowerCase().contains(query))
            .toList();
      }
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: _buildCharactersList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar personaje...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blueGrey,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCharactersList() {
    if (_filteredCharacters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron personajes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otro término de búsqueda',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _filteredCharacters.length,
      itemBuilder: (context, index) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
          ),
          child: _CharacterCard(
            name: _filteredCharacters[index]['name']!,
            status: _filteredCharacters[index]['status']!,
            species: _filteredCharacters[index]['species']!,
            emoji: _filteredCharacters[index]['emoji']!,
            favoritesManager: _favoritesManager,
          ),
        );
      },
    );
  }
}

class _CharacterCard extends StatefulWidget {
  final String name;
  final String status;
  final String species;
  final String emoji;
  final FavoritesManager favoritesManager;

  const _CharacterCard({
    required this.name,
    required this.status,
    required this.species,
    required this.emoji,
    required this.favoritesManager,
  });

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.favoritesManager.isFavorite(widget.name);
    // Escuchar cambios en favoritos
    widget.favoritesManager.favoritesChanged.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    widget.favoritesManager.favoritesChanged.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {
      _isFavorited = widget.favoritesManager.isFavorite(widget.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAlive = widget.status == 'Alive';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isAlive ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isAlive ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAlive ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isAlive ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAlive ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.species,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _isFavorited ? 1.2 : 1.0,
          child: IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? Colors.red : Colors.grey[400],
            ),
            onPressed: () {
              widget.favoritesManager.toggleFavorite(widget.name);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorited
                        ? '${widget.name} removido de favoritos'
                        : '${widget.name} añadido a favoritos',
                  ),
                  duration: const Duration(milliseconds: 800),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _isFavorited ? Colors.grey[700] : Colors.green,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
