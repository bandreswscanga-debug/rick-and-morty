// Importa Flutter (UI básica)
import 'package:flutter/material.dart';

// Importa Provider (para manejo de estado global)
import 'package:provider/provider.dart';

// Importa tu archivo del estado global
import 'provider/character_provider.dart';

void main() {
  runApp(
    // Aquí envuelves TODA la app con el Provider
    ChangeNotifierProvider(
      create: (_) => CharacterProvider(), // Se crea la instancia global
      child: const MyApp(), // Se ejecuta la app
    ),
  );
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagina Music', // Título de la app
      home: Scaffold(
        // Estructura visual básica
        appBar: AppBar(
          title: const Text('Pagina Music'), // Barra superior
        ),

        body: Center(
          // Consumer escucha cambios del Provider
          child: Consumer<CharacterProvider>(
            builder: (context, provider, child) {

              // Verifica si el personaje con ID 1 es favorito
              final isFav = provider.isFavorite(1);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Muestra si es favorito o no
                  Text(isFav ? 'Favorito: Sí' : 'Favorito: No'),

                  const SizedBox(height: 8),

                  // Botón para agregar/quitar de favoritos
                  ElevatedButton(
                    onPressed: () => provider.toggleFavorite(1),

                    // Llama al método del provider
                    child: const Text('Alternar favorito'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}