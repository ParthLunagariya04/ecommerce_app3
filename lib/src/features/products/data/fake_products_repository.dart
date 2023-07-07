import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  //singleton
  // FakeProductsRepository._();
  // static FakeProductsRepository instance = FakeProductsRepository._();

  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  //synchronous method
  List<Product> getProductList() {
    return _products.value;
  }

  Product? getProduct(String id) {
    return _getProduct(_products.value, id);
  }

  //asynchronous method
  Future<List<Product>> fetchProductList() async {
    //throw Exception('Connection failed');
    return Future.value(_products.value);
  }

  Stream<List<Product>> watchProductsList() {
    return _products.stream;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  /// Update product or add a new one
  Future<void> setProduct(Product product) async {
    await delay(addDelay);
    final products = _products.value;
    final index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      // if not found, add as a new product
      products.add(product);
    } else {
      // else, overwrite previous product
      products[index] = product;
    }
    _products.value = products;
  }

  /// Search for products where the title contains the search query
  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small. '
      'Consider doing server-side search for larger datasets.',
    );
    // Get all products
    final productsList = await fetchProductList();
    // Match all products where the title contains the query
    return productsList
        .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Product? _getProduct(List<Product> product, String id) {
    try {
      return product.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

// provider
final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository(addDelay: false);
});

// stream provider
final productListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint("created productListStreamProvider");
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductsList();
});

// future provider
final productListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductList();
});

//using family
final productProvider = StreamProvider.autoDispose.family<Product?, String>(
  (ref, id) {
    debugPrint("created productProvider with id : $id ");
    ref.onDispose(() => debugPrint('disposed productProvider'));
    // this is use for data cashing
    final link = ref.keepAlive();
    Timer(const Duration(seconds: 4), () {
      link.close();
    });
    final productRepository = ref.watch(productRepositoryProvider);
    return productRepository.watchProduct(id);
  },
);

final productListSearchProvider =
    FutureProvider.autoDispose.family<List<Product>, String>((ref, query) async {
  // ref.onDispose(() => debugPrint('disposed: $query'));
  // ref.onCancel(() => debugPrint('cancel: $query'));
  // this is use for data cashing
  final link = ref.keepAlive();
  Timer(const Duration(seconds: 5), () {
    link.close();
  });
  //await Future.delayed(const Duration(milliseconds: 500));
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.searchProducts(query);
});
