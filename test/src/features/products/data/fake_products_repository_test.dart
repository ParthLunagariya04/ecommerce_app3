import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductRepository() =>
      FakeProductsRepository(addDelay: false);
  group('FakeProduckRepository', () {
    test('getProductList return global list', () {
      final productRepository = makeProductRepository();
      expect(productRepository.getProductList(), kTestProducts);
    });

    test('getProduct(1) returns first item', () {
      final productRepository = makeProductRepository();
      expect(productRepository.getProduct('1'), kTestProducts[0]);
    });

    test('getProduct(100) returns null', () {
      final productRepository = makeProductRepository();
      expect(productRepository.getProduct('100'), null);
    });
  });

  test('fakeProductList return global list', () async {
    final productRepository = makeProductRepository();
    expect(
      await productRepository.fetchProductList(),
      kTestProducts,
    );
  });

  //stream method
  test('watchProductList emits global list', () {
    final productRepository = makeProductRepository();
    expect(
      productRepository.watchProductList(),
      emits(kTestProducts),
    );
  });

  test('watchProduct(1) emits first item', () {
    final productRepository = makeProductRepository();
    expect(
      productRepository.watchProduct('1'),
      emits(kTestProducts[0]),
    );
  });

  test('watchProduct(100) emits null', () {
    final productRepository = makeProductRepository();
    expect(
      productRepository.watchProduct('100'),
      emits(null),
    );
  });
}
