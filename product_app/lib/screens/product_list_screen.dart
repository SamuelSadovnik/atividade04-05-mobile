import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/screens/product_detail_screen.dart';
import 'package:product_app/screens/product_form_screen.dart';
import 'package:product_app/services/product_service.dart';
import 'package:product_app/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _service = ProductService();
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _service.fetchProducts();
  }

  void _reloadProducts() {
    setState(() {
      _futureProducts = _service.fetchProducts();
    });
  }

  Future<void> _openCreateScreen() async {
    final created = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const ProductFormScreen()),
    );

    if (created == null) {
      return;
    }

    await _service.addProduct(created);
    _reloadProducts();
  }

  Future<void> _openEditScreen(Product product) async {
    final updated = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(initialProduct: product),
      ),
    );

    if (updated == null) {
      return;
    }

    await _service.updateProduct(updated);
    _reloadProducts();
  }

  Future<void> _deleteProduct(Product product) async {
    if (product.id == null) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusao'),
        content: Text('Deseja excluir "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    await _service.deleteProduct(product.id!.toString());
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto excluido com sucesso')),
    );
    _reloadProducts();
  }

  Future<void> _showError(Object error) async {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _reloadProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Erro ao carregar produtos'),
                    const SizedBox(height: 12),
                    Text('${snapshot.error}'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reloadProducts,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          }

          return RefreshIndicator(
            onRefresh: () async => _reloadProducts(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  onEdit: () async {
                    try {
                      await _openEditScreen(product);
                    } catch (error) {
                      await _showError(error);
                    }
                  },
                  onDelete: () async {
                    try {
                      await _deleteProduct(product);
                    } catch (error) {
                      await _showError(error);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            await _openCreateScreen();
          } catch (error) {
            await _showError(error);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
