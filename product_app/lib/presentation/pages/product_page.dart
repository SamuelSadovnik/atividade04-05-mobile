import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/presentation/viewmodels/product_state.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Produtos")),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(productViewModelProvider.notifier).loadProducts(),
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ProductState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(state.error!),
      );
    }

    return ListView.builder(
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.broken_image_outlined),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
            ),
          ),
          title: Text(product.title),
          subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
          trailing: IconButton(
            onPressed: () {
              ref.read(productViewModelProvider.notifier).toggleFavorite(product.id);
            },
            icon: Icon(
              product.favorite ? Icons.star : Icons.star_border,
              color: product.favorite ? Colors.amber : null,
            ),
          ),
        );
      },
    );
  }
}
