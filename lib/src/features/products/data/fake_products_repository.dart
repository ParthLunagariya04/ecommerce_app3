import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

class FakeProductsRepository {
  //singleton
  FakeProductsRepository._();
  static FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _product = kTestProducts;

  //synchronous method
  List<Product> getProductList() {
    return _product;
  }

  Product? getProduct(String id) {
    return _product.firstWhere((product) => product.id == id);
  }

  //asynchronous method
  Future<List<Product>> fetchProductList() {
    return Future.value(_product);
  }

  Stream<List<Product>> watchProductList() {
    return Stream.value(_product);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList().map((products) => products.firstWhere((product) => product.id == id));
  }
}
