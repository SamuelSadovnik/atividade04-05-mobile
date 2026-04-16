import 'package:flutter/material.dart';
import 'package:product_app/screens/product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListScreen()),
            );
          },
          icon: const Icon(Icons.shopping_bag_outlined),
          label: const Text('Ver Produtos'),
        ),
      ),
    );
  }
}
