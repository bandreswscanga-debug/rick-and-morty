import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String key = 'favorites';

  // Guardar favoritos
  static Future<void> save(List<String> favs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, favs);
  }



   // Cargar favoritos
  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }
}