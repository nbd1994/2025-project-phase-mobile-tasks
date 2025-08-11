import 'dart:convert';

import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product_mgt/data/datasources/product_mgt_local_data_source.dart';
import 'package:ecommerce_app/features/product_mgt/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/get_fixtures.dart';
import 'product_mgt_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProductMgtLocalDataSourceImpl localDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;
  final List<dynamic> jsnList = json.decode(getFixture('products_cached.json'));
  final List<ProductModel> tProducts =
      jsnList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
  final ProductModel tproduct = tProducts[0];
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImpl = ProductMgtLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });
group('all', (){


  group('getCachedProducts', () {
    test(
      'should return list of cached products if if they are available',
      () async {
        when(
          mockSharedPreferences.getString(any),
        ).thenReturn(getFixture('products_cached.json'));
        final result = await localDataSourceImpl.getCachedProducts();
        verify(mockSharedPreferences.getString(CACHED_PRODUCTS));
        expect(result, tProducts);
      },
    );
    test('should throw cache exception if anavailable', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final res = localDataSourceImpl.getCachedProducts;
      expect(() => res(), throwsA(isA<CacheException>()));
    });
  });

  group('getCachedSingleProduct', () {
    test('should return the product if it exists in cache', () async {
      // Arrange
      when(
        mockSharedPreferences.getString(any),
      ).thenReturn(getFixture('products_cached.json'));

      // Act
      final result = await localDataSourceImpl.getCachedSingleProduct(
        tproduct.id,
      );

      // Assert
      verify(mockSharedPreferences.getString(CACHED_PRODUCTS));
      expect(result, tproduct);
    });

    test('should throw CacheException if cache is empty', () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // Assert
      expect(
        () => localDataSourceImpl.getCachedSingleProduct(tproduct.id),
        throwsA(isA<CacheException>()),
      );
    });

    test('should throw CacheException if product is not found', () async {
      // Arrange
      when(
        mockSharedPreferences.getString(any),
      ).thenReturn(getFixture('products_cached.json'));

      // Assert
      expect(
        () => localDataSourceImpl.getCachedSingleProduct('1000'),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheProducts', () {
    test('should call SharedPreferences to cache the products', () async {
      // Arrange
      final expectedJsonString = json.encode(
        tProducts.map((p) => p.toJson()).toList(),
      );
      when(
        mockSharedPreferences.setString(CACHED_PRODUCTS, expectedJsonString),
      ).thenAnswer((_) async => true);

      // Act
      await localDataSourceImpl.cacheProducts(tProducts);

      // Assert
      verify(
        mockSharedPreferences.setString(CACHED_PRODUCTS, expectedJsonString),
      );
    });

    test('should throw CacheException if an error occurs', () async {
      // Arrange
      when(mockSharedPreferences.setString(any, any)).thenThrow(Exception());

      // Assert
      expect(
        () => localDataSourceImpl.cacheProducts(tProducts),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheSingleProduct', () {
    test('should add a new product if it does not exist', () async {
      // Arrange: Start with an empty cache
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // Act
      await localDataSourceImpl.cacheSingleProduct(tproduct);

      // Assert: Should save a list with the new product
      final expectedJsonString = json.encode([tproduct.toJson()]);
      verify(
        mockSharedPreferences.setString(CACHED_PRODUCTS, expectedJsonString),
      );
    });

    test('should update the product if it already exists', () async {
      // Arrange: Cache already contains the product
      final updatedProduct = ProductModel(id: tproduct.id, name: 'Updated Name', price: tproduct.price, imageUrl: tproduct.imageUrl, description: tproduct.description);
      final initialJsonString = json.encode([tproduct.toJson()]);
      when(mockSharedPreferences.getString(any)).thenReturn(initialJsonString);
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // Act
      await localDataSourceImpl.cacheSingleProduct(updatedProduct);

      // Assert: Should save a list with the updated product
      final expectedJsonString = json.encode([updatedProduct.toJson()]);
      verify(
        mockSharedPreferences.setString(CACHED_PRODUCTS, expectedJsonString),
      );
    });

    test('should throw CacheException if an error occurs', () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenThrow(Exception());

      // Assert
      expect(
        () => localDataSourceImpl.cacheSingleProduct(tproduct),
        throwsA(isA<CacheException>()),
      );
    });
  });

  });
}
