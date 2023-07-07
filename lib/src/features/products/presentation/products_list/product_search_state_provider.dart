import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productSearchQueryStateProvider = StateProvider<String>((ref) {
  return '';
});

final productsSearchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final searchQuery = ref.watch(productSearchQueryStateProvider);
  return ref.watch(productListSearchProvider(searchQuery).future);
});
