import 'dart:convert';

import 'package:ecommerce_app/features/product_mgt/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/get_fixtures.dart';

void main() {
  final tproduct = ProductModel(
    id: 1,
    name: 'Sample Product',
    price: 19.99,
    imageUrl: 'https://example.com/image.jpg',
    description: 'A sample product description.',
  );
  group('json', () {
    test(
      'from json - should return valid product instance from json',
      () async {
        final Map<String, dynamic> jsn = json.decode(
          getFixture('product.json'),
        );
        final result = ProductModel.fromJson(jsn);
        expect(result, tproduct);
      },
    );

    test('toJson - should change the product model to json', () async {
      final Map<String, dynamic> jsn = tproduct.toJson();
      final expected = {
        'id': 1,
        'name': 'Sample Product',
        'price': 19.99,
        'imageUrl': 'https://example.com/image.jpg',
        'description': 'A sample product description.',
      };
      expect(jsn, expected);
    });
  });
}
