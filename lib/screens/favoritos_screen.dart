import 'package:flutter/material.dart';
import '../services/favorites_manager.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
    // Escuchar cambios en favoritos
    _favoritesManager.favoritesChanged.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _favoritesManager.favoritesChanged.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    // Reanimar cuando cambien los favoritos
    _animationController.forward(from: 0.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = _favoritesManager.getFavorites();
    
    return favoritos.isEmpty
        ? _buildEmptyState()
        : _buildFavoritosList(favoritos);
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

  Widget _buildFavoritosList(List<Character> favoritos) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: favoritos.length,
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
            character: favoritos[index],
            favoritesManager: _favoritesManager,
          ),
        );
      },
    );
  }
}

class _FavoritoCard extends StatefulWidget {
  final Character character;
  final FavoritesManager favoritesManager;

  const _FavoritoCard({
    required this.character,
    required this.favoritesManager,
  });

  @override
  State<_FavoritoCard> createState() => _FavoritoCardState();
}

class _FavoritoCardState extends State<_FavoritoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isAlive = widget.character.status == 'Alive';

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
                    widget.character.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              title: Text(
                widget.character.name,
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
                        widget.character.species,
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
                        widget.character.status,
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
                onPressed: () {
                  widget.favoritesManager.removeFavorite(widget.character.name);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.character.name} removido de favoritos'),
                      duration: const Duration(milliseconds: 900),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.grey[700],
                      action: SnackBarAction(
                        label: 'Deshacer',
                        onPressed: () {
                          widget.favoritesManager.addFavorite(widget.character.name);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
