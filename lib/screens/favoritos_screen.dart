import 'package:flutter/material.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, String>> _favoritos = [
    {
      'name': 'Rick Sanchez',
      'species': 'Human',
      'status': 'Alive',
      'emoji': '👨‍🔬'
    },
    {
      'name': 'Morty Smith',
      'species': 'Human',
      'status': 'Alive',
      'emoji': '👦'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _favoritos.isEmpty
        ? _buildEmptyState()
        : _buildFavoritosList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
            ),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red[200]!, width: 3),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 60,
                color: Colors.red[300],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Sin favoritos aún',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Agrega personajes a tu lista de favoritos\npara que aparezcan aquí',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navegar a la pestaña Explorar
              // Esto se implementará con Provider
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explorar personajes'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritosList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _favoritos.length,
      itemBuilder: (context, index) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    index * 0.1,
                    (index * 0.1) + 0.5,
                    curve: Curves.easeOut,
                  ),
                ),
              ),
          child: _FavoritoCard(
            name: _favoritos[index]['name']!,
            species: _favoritos[index]['species']!,
            status: _favoritos[index]['status']!,
            emoji: _favoritos[index]['emoji']!,
            onRemove: () {
              setState(() {
                _favoritos.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_favoritos[index]['name']} removido de favoritos'),
                  duration: const Duration(milliseconds: 900),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.grey[700],
                  action: SnackBarAction(
                    label: 'Deshacer',
                    onPressed: () {
                      setState(() {
                        _favoritos.insert(
                          index,
                          {
                            'name': _favoritos[index]['name']!,
                            'species': _favoritos[index]['species']!,
                            'status': _favoritos[index]['status']!,
                            'emoji': _favoritos[index]['emoji']!,
                          },
                        );
                      });
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _FavoritoCard extends StatefulWidget {
  final String name;
  final String species;
  final String status;
  final String emoji;
  final VoidCallback onRemove;

  const _FavoritoCard({
    required this.name,
    required this.species,
    required this.status,
    required this.emoji,
    required this.onRemove,
  });

  @override
  State<_FavoritoCard> createState() => _FavoritoCardState();
}

class _FavoritoCardState extends State<_FavoritoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isAlive = widget.status == 'Alive';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()
        ..translate(_isHovered ? 4.0 : 0.0, 0.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red[100]!,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[100]!, Colors.red[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 28),
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
                child: Wrap(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue[300]!),
                      ),
                      child: Text(
                        widget.species,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isAlive ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isAlive ? Colors.green[300]! : Colors.red[300]!,
                        ),
                      ),
                      child: Text(
                        widget.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: isAlive ? Colors.green[700] : Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: widget.onRemove,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
