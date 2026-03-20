import 'package:flutter/material.dart';

/// Clase para gestionar constantes de la aplicación
class AppConstants {
  AppConstants._();

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 2);

  // Strings
  static const String appTitle = 'Rick and Morty';
  static const String exploreLabel = 'Explorar';
  static const String favoritesLabel = 'Favoritos';
  static const String searchHint = 'Buscar personaje...';
  static const String noCharactersFound = 'No se encontraron personajes';
  static const String noFavorites = 'Sin favoritos aún';
  static const String addFavoritesHint = 'Agrega personajes a tu lista de favoritos';

  // Sizes
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double emptyStateIconSize = 80.0;
  static const double cardElevation = 2.0;

  // Animations
  static const Curve defaultCurve = Curves.easeInOut;
}
