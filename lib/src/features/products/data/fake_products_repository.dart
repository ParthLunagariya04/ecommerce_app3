import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  //singleton
  // FakeProductsRepository._();
  // static FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _product = kTestProducts;

  //synchronous method
  List<Product> getProductList() {
    return _product;
  }

  Product? getProduct(String id) {
    return _product.firstWhere((product) => product.id == id);
  }

  //asynchronous method
  Future<List<Product>> fetchProductList() async {
    await Future.delayed(const Duration(seconds: 2));
    //throw Exception('Connection failed');
    return Future.value(_product);
  }

  Stream<List<Product>> watchProductList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _product;
    //return Stream.value(_product);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

// provider
final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

// stream provider
final productListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint("created productListStreamProvider");
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductList();
});

// future provider
final productListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
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
