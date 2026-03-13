import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/core/network/http_client.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/viewmodels/product_state.dart';

final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient();
});

final productRemoteDatasourceProvider = Provider<ProductRemoteDatasource>((ref) {
  return ProductRemoteDatasource(ref.read(httpClientProvider));
});

final productCacheDatasourceProvider = Provider<ProductCacheDatasource>((ref) {
  return ProductCacheDatasource();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    ref.read(productRemoteDatasourceProvider),
    ref.read(productCacheDatasourceProvider),
  );
});

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, ProductState>((ref) {
  final viewModel = ProductViewModel(ref.read(productRepositoryProvider));
  viewModel.loadProducts();
  return viewModel;
});

class ProductViewModel extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductViewModel(this.repository) : super(const ProductState());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state = state.copyWith(
        isLoading: false,
        products: products,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void toggleFavorite(int productId) {
    final updatedProducts = state.products.map((product) {
      if (product.id != productId) {
        return product;
      }
      return _toggleProductFavorite(product);
    }).toList();

    state = state.copyWith(products: updatedProducts);
  }

  Product _toggleProductFavorite(Product product) {
    return product.copyWith(favorite: !product.favorite);
  }
}
