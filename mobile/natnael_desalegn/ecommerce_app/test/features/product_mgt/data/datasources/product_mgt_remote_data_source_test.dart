import 'dart:convert';

import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product_mgt/data/datasources/product_mgt_remote_data_source.dart';
import 'package:ecommerce_app/features/product_mgt/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/get_fixtures.dart';
import 'product_mgt_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductMgtRemoteDataSourceImpl remoteDataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSourceImpl = ProductMgtRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  final tId = 1;
  final ProductModel tProductModel = const ProductModel(
    id: 1,
    name: 'Sample Product',
    price: 19.99,
    imageUrl: 'https://example.com/image.jpg',
    description: 'A sample product description.',
  );
  test('should perform a get request with application/json header', () async {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(getFixture('product.json'), 200));
    remoteDataSourceImpl.getProduct(tId);

    verify(
      mockHttpClient.get(
        Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$tId',
        ),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  });

  group('getProduct', () {
    test('should return valid product', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response(getFixture('product.json'), 200));
      final response = await remoteDataSourceImpl.getProduct(tId);
      expect(response, equals(tProductModel));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Something went wrong', 404));
        // act
        // assert
        expect(
          () => remoteDataSourceImpl.getProduct(tId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get all products', () {
    test(
      'should return a list of ProductModel when the response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(getFixture('products_cached.json'), 200),
        );
        final List<dynamic> jsnList = json.decode(
          getFixture('products_cached.json'),
        );
        final expectedProducts =
            jsnList
                .map(
                  (item) => ProductModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();

        // act
        final result = await remoteDataSourceImpl.getAllProducts();

        // assert
        expect(result, equals(expectedProducts));
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Something went wrong', 404));

        // assert
        expect(
          () => remoteDataSourceImpl.getAllProducts(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
  group('delete Product', () {
    test('should return ProductModel when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.delete(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response(getFixture('product.json'), 200));

      // act
      final result = await remoteDataSourceImpl.deleteProduct(tId);

      // assert
      expect(result, equals(tProductModel));
    });

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.delete(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Something went wrong', 404));
        // assert
        expect(
          () => remoteDataSourceImpl.deleteProduct(tId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('insert a product', () {
    test(
      'should return ProductModel when the response code is 201 or 200',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(getFixture('product.json'), 201),
        );

        // act
        final result = await remoteDataSourceImpl.insertProduct(tProductModel);

        // assert
        expect(result, equals(tProductModel));
      },
    );

    test(
      'should throw a ServerException when the response code is not 201 or 200',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Something went wrong', 400));

        // assert
        expect(
          () => remoteDataSourceImpl.insertProduct(tProductModel),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('update product', () {
    test('should return ProductModel when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(getFixture('product.json'), 200));

      // act
      final result = await remoteDataSourceImpl.updateProduct(tProductModel);

      // assert
      expect(result, equals(tProductModel));
    });

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.put(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Something went wrong', 400));

        // assert
        expect(
          () => remoteDataSourceImpl.updateProduct(tProductModel),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
