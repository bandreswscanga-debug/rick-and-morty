import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa un personaje
class Character {
  final String name;
  final String status;
  final String species;
  final String emoji;
  bool isFavorite;

  Character({
    required this.name,
    required this.status,
    required this.species,
    required this.emoji,
    this.isFavorite = false,
  });
}

/// Servicio singleton para gestionar favoritos globalmente
class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  static const String _storageKey = 'favorite_characters';

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  // Lista de todos los personajes disponibles
  final List<Character> _allCharacters = [
    Character(
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      emoji: '👨‍🔬',
      isFavorite: false,
    ),
    Character(
      name: 'Morty Smith',
      status: 'Alive',
      species: 'Human',
      emoji: '👦',
      isFavorite: false,
    ),
    Character(
      name: 'Summer Smith',
      status: 'Alive',
      species: 'Human',
      emoji: '👧',
      isFavorite: false,
    ),
    Character(
      name: 'Jerry Smith',
      status: 'Alive',
      species: 'Human',
      emoji: '👨',
      isFavorite: false,
    ),
    Character(
      name: 'Beth Smith',
      status: 'Alive',
      species: 'Human',
      emoji: '👩',
      isFavorite: false,
    ),
    Character(
      name: 'Jessica',
      status: 'Alive',
      species: 'Human',
      emoji: '👩‍🦰',
      isFavorite: false,
    ),
    Character(
      name: 'Squanchy',
      status: 'Alive',
      species: 'Squanch',
      emoji: '🐯',
      isFavorite: false,
    ),
    Character(
      name: 'Birdperson',
      status: 'Dead',
      species: 'Birdperson',
      emoji: '🦅',
      isFavorite: false,
    ),
  ];

  // Notificadores para cambios
  final ValueNotifier<List<Character>> favoritesChanged =
      ValueNotifier<List<Character>>([]);

  /// Inicializa el servicio cargando los favoritos guardados
  Future<void> initialize() async {
    if (_initialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    final savedFavorites = _prefs.getStringList(_storageKey) ?? [];
    
    // Cargar favoritos guardados
    for (final character in _allCharacters) {
      character.isFavorite = savedFavorites.contains(character.name);
    }
    
    _initialized = true;
    _notifyChanges();
  }

  /// Obtiene todos los personajes
  List<Character> getAllCharacters() => List.from(_allCharacters);

  /// Obtiene los favoritos actuales
  List<Character> getFavorites() {
    return _allCharacters.where((char) => char.isFavorite).toList();
  }

  /// Añade un personaje a favoritos
  void addFavorite(String characterName) {
    final character = _allCharacters.firstWhere(
      (char) => char.name == characterName,
      orElse: () => Character(
        name: '',
        status: '',
        species: '',
        emoji: '',
      ),
    );

    if (character.name.isNotEmpty && !character.isFavorite) {
      character.isFavorite = true;
      _saveFavorites();
      _notifyChanges();
    }
  }

  /// Remueve un personaje de favoritos
  void removeFavorite(String characterName) {
    final character = _allCharacters.firstWhere(
      (char) => char.name == characterName,
      orElse: () => Character(
        name: '',
        status: '',
        species: '',
        emoji: '',
      ),
    );

    if (character.name.isNotEmpty && character.isFavorite) {
      character.isFavorite = false;
      _saveFavorites();
      _notifyChanges();
    }
  }

  /// Alterna favorito
  void toggleFavorite(String characterName) {
    final character = _allCharacters.firstWhere(
      (char) => char.name == characterName,
      orElse: () => Character(
        name: '',
        status: '',
        species: '',
        emoji: '',
      ),
    );

    if (character.name.isNotEmpty) {
      character.isFavorite = !character.isFavorite;
      _saveFavorites();
      _notifyChanges();
    }
  }

  /// Verifica si un personaje es favorito
  bool isFavorite(String characterName) {
    return _allCharacters
        .firstWhere(
          (char) => char.name == characterName,
          orElse: () => Character(
            name: '',
            status: '',
            species: '',
            emoji: '',
          ),
        )
        .isFavorite;
  }

  /// Notifica a los listeners sobre cambios
  void _notifyChanges() {
    favoritesChanged.value = List.from(getFavorites());
  }

  /// Guarda los favoritos en disco
  void _saveFavorites() {
    if (!_initialized) return;
    
    final favoriteNames = _allCharacters
        .where((char) => char.isFavorite)
        .map((char) => char.name)
        .toList();
    
    _prefs.setStringList(_storageKey, favoriteNames);
  }
}
