import 'package:flutter/material.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final List<Map<String, String>> _favoritos = [
    {'name': 'Rick Sanchez', 'species': 'Human'},
    {'name': 'Morty Smith', 'species': 'Human'},
  ];

  @override
  Widget build(BuildContext context) {
    return _favoritos.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sin favoritos aún',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrega personajes a tu lista de favoritos',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _favoritos.length,
            itemBuilder: (context, index) {
              final favorito = _favoritos[index];
              return _FavoritoCard(
                name: favorito['name']!,
                species: favorito['species']!,
                onRemove: () {
                  setState(() {
                    _favoritos.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${favorito['name']} removido de favoritos'),
                      action: SnackBarAction(
                        label: 'Deshacer',
                        onPressed: () {
                          setState(() {
                            _favoritos.insert(index, favorito);
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}

class _FavoritoCard extends StatelessWidget {
  final String name;
  final String species;
  final VoidCallback onRemove;

  const _FavoritoCard({
    required this.name,
    required this.species,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Especie: $species'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
