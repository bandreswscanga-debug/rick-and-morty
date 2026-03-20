import 'package:flutter/material.dart';

// Clase que maneja el estado global de la app
// Extiende ChangeNotifier para poder notificar cambios a la UI
class CharacterProvider extends ChangeNotifier {

  // Lista privada donde se guardan los IDs de personajes favoritos
  List<int> _favorites = [];

  // Getter público para acceder a la lista de favoritos
  // (sin permitir modificarla directamente desde fuera)
  List<int> get favorites => _favorites;

  // Método para agregar o quitar un personaje de favoritos
  void toggleFavorite(int characterId) {

    // Si el personaje YA está en favoritos → lo elimina
    if (_favorites.contains(characterId)) {
      _favorites.remove(characterId);

    } else {
      // Si NO está → lo agrega
      _favorites.add(characterId);
    }

    // Notifica a toda la app que hubo cambios
    // Esto hace que los widgets (Consumer) se actualicen automáticamente
    notifyListeners();
  }

  // Método para verificar si un personaje es favorito
  bool isFavorite(int characterId) {

    // Retorna true si el ID está en la lista
    return _favorites.contains(characterId);
  }
}