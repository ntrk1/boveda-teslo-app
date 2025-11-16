


import 'package:teslo_shop/features/products/products.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsBypage({int limit = 10, offset = 0});
  Future<Product> getProductsById(String id);

  Future<List<Product>> getProductsByTerm(String term);
  Future<Product> createUpdateeProduct(Map<String, dynamic> productLike);
}