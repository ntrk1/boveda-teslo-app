

import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/products/products.dart';

class HypoProductState {
  final Product? product;
  final String id;
  final bool isLoading;
  final bool isSaving;

  HypoProductState({
    required this.id, 
    this.product, 
    this.isLoading = true, 
    this.isSaving = false
    });

    HypoProductState copyWith({
      String? id,
      Product? product,
      bool? isLoading,
      bool? isSaving,
    }) => HypoProductState(
      product: product ?? this.product,
      id: id ?? this.id,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
}

class HypoProductNotifier extends StateNotifier<HypoProductState>{
  final ProductsRepository productsRepository;

  HypoProductNotifier({
    required this.productsRepository,
    required String productId
    }): super(HypoProductState(id: productId)) {
      loadProduct();
    }

  Product newEmptyproduct() {
    return Product(
      id: 'new', 
      title: '', 
      price: 0, 
      description: '', 
      slug: '', 
      stock: 0, 
      sizes: [''], 
      gender: 'men', 
      tags: [], 
      images: [],
      );
  }


  Future<void> loadProduct() async {
    try {
      if(state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: newEmptyproduct()
        );
        return;
      }
      final product = await productsRepository.getProductsById(state.id);

      state = state.copyWith(
        isLoading: false,
        product: product
      );
    } catch (e) {
      throw UnimplementedError();
    }
  }
}


final hypoProductProvider = StateNotifierProvider.autoDispose.family<HypoProductNotifier, HypoProductState, String>(
  (ref, productId) {
  final producRepository = ref.watch(productRepositoryProvider);
  return HypoProductNotifier(
    productsRepository: producRepository, 
    productId: productId
    );
});