import 'package:flutter/material.dart';

class ExplorarScreen extends StatelessWidget {
  const ExplorarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 80,
            color: Colors.blueGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'Explorar',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Busca personajes de Rick and Morty',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
