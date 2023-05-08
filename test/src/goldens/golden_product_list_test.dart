import 'package:ecommerce_app/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });
  testWidgets(
    'Golden - product list',
    (tester) async {
      final r = Robot(tester);
      final currentSize = sizeVariant.currentValue!;
      await r.golden.setSurfaceSize(currentSize);
      await r.golden.loadRobotoFont();
      await r.golden.loadMaterialIconFont();
      await r.pumpMyApp();
      await r.golden.precacheImages();
      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('products_list_${currentSize.width.toInt()}_${currentSize.height.toInt()}.png'),
      );
    },
    variant: sizeVariant,
    // flutter test --update-goldens --tags=golden
    // above command is only for run golden image test using tags
    tags: ['golden']
  );
}
