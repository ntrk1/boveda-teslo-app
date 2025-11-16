

import 'package:teslo_shop/features/products/products.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImpl({required this.datasource});
  @override
  Future<Product> createUpdateeProduct(Map<String, dynamic> productLike) {
    return datasource.createUpdateeProduct(productLike);
  }

  @override
  Future<Product> getProductsById(String id) {
    return datasource.getProductsById(id);
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    return datasource.getProductsByTerm(term);
  }

  @override
  Future<List<Product>> getProductsBypage({int limit = 10, offset = 0}) {
    return datasource.getProductsBypage(limit: limit, offset: offset);
  }
}