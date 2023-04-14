import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  //singleton
  // FakeProductsRepository._();
  // static FakeProductsRepository instance = FakeProductsRepository._();

  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;
  final List<Product> _product = kTestProducts;

  //synchronous method
  List<Product> getProductList() {
    return _product;
  }

  Product? getProduct(String id) {
    return _getProduct(_product, id);
  }

  //asynchronous method
  Future<List<Product>> fetchProductList() async {
    await delay(addDelay);
    //throw Exception('Connection failed');
    return Future.value(_product);
  }

  Stream<List<Product>> watchProductList() async* {
    await delay(addDelay);
    yield _product;
    //return Stream.value(_product);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList().map((products) => _getProduct(_product, id));
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
