


import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/products/products.dart';


class EpiProducstState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  EpiProducstState({
     this.isLastPage = false, 
     this.limit = 10, 
     this.offset = 0, 
     this.isLoading = false, 
     this.products = const []
    });
    EpiProducstState copyWith({
      bool? isLastPage,
      int? limit,
      int? offset,
      bool? isLoading,
      List<Product>? products,
    }) => EpiProducstState(
      isLastPage : isLastPage ?? this.isLastPage,
      limit : limit ?? this.limit,
      offset : offset ?? this.offset,
      isLoading : isLoading ?? this.isLoading,
      products : products ?? this.products,
    );
    }


    class EpiProducstNotifier extends StateNotifier<EpiProducstState> {
      final ProductsRepository productsRepository;

   EpiProducstNotifier({required this.productsRepository
   }) : super (EpiProducstState()) {
    loadNextPage();
   }
   
   Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateeProduct(productLike);
      final isProductInList = state.products.any(
        (element) => element.id == product.id);
        if (!isProductInList) {
          state = state.copyWith(
            products: [...state.products, product]
          );
          return true;
        }

        state = state.copyWith(
          products: state.products.map(
            (element) => (element.id == product.id) ? product : element,
          ).toList()
        );
        return true;
    } catch (e) {
      return false;
    }
   }

   Future loadNextPage() async {
    if(state.isLoading || state.isLastPage) return;
    state = state.copyWith(isLoading: true);

    final products = await productsRepository
    .getProductsBypage(limit: state.limit, offset: state.offset);
    if(products.isEmpty) {
      state = state.copyWith(
        isLastPage : true,
        isLoading : false, 
        );
        return;
    }
    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products]
    );
   }
    }

final epiProductsProvider = StateNotifierProvider<EpiProducstNotifier, EpiProducstState> (
  (ref) {
    final producRepository = ref.watch(productRepositoryProvider);
    return EpiProducstNotifier(productsRepository: producRepository);
  },
);

