import 'package:dio/dio.dart';
import 'package:product_app/models/product.dart';

class ProductService {
  ProductService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get(_baseUrl);
    final data = response.data as List<dynamic>;
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await _dio.post(
      _baseUrl,
      data: product.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    return Product.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw ArgumentError('Product id is required to update a product');
    }

    final response = await _dio.put(
      '$_baseUrl/${product.id}',
      data: product.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    return Product.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete('$_baseUrl/$id');
  }
}
