import 'package:flutter/material.dart';
import 'package:product_app/presentation/pages/product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductPage()),
            );
          },
          icon: const Icon(Icons.shopping_bag_outlined),
          label: const Text('Ver Produtos'),
        ),
      ),
    );
  }
}
