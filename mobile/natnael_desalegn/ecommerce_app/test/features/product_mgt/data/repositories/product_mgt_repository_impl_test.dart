import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product_mgt/data/datasources/product_mgt_local_data_source.dart';
import 'package:ecommerce_app/features/product_mgt/data/datasources/product_mgt_remote_data_source.dart';
import 'package:ecommerce_app/features/product_mgt/data/models/product_model.dart';
import 'package:ecommerce_app/features/product_mgt/data/repositories/product_mgt_repository_impl.dart';
import 'package:ecommerce_app/features/product_mgt/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_mgt_repository_impl_test.mocks.dart';

@GenerateMocks([
  NetworkInfo,
  ProductMgtLocalDataSource,
  ProductMgtRemoteDataSource,
])
void main() {
  final tId = 1;
  final ProductModel tproductModel = ProductModel(
    id: 1,
    name: 'Sample Product',
    price: 19.99,
    imageUrl: 'https://example.com/image.jpg',
    description: 'A sample product description.',
  );
  final Product tproduct = tproductModel;
  final tProducts = [tproductModel];

  late ProductMgtRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;
  late MockProductMgtLocalDataSource mockProductMgtLocalDataSource;
  late MockProductMgtRemoteDataSource mockProductMgtRemoteDataSource;

  setUp(() {
    mockProductMgtRemoteDataSource = MockProductMgtRemoteDataSource();
    mockProductMgtLocalDataSource = MockProductMgtLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductMgtRepositoryImpl(
      productMgtRemoteDataSouce: mockProductMgtRemoteDataSource,
      productMgtLocalDataSource: mockProductMgtLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  test('check if the device is online', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    repository.getAllProducts();
    verify(mockNetworkInfo.isConnected);
  });

  group('when the device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'delete - should delete the product from the remote data source if the call is successful',
      () async {
        when(
          mockProductMgtRemoteDataSource.deleteProduct(tId),
        ).thenAnswer((_) async => tproductModel);
        await repository.deleteProduct(tId);
        verify(mockProductMgtRemoteDataSource.deleteProduct(tId));
      },
    );

    test(
      'delete - should throw server Failure when the call to remote data source is unsuccessful',
      () async {
        when(
          mockProductMgtRemoteDataSource.deleteProduct(tId),
        ).thenThrow(ServerException());
        final result = await repository.deleteProduct(tId);

        verify(mockProductMgtRemoteDataSource.deleteProduct(tId));
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'getProduct - should return Product when the call to remote data source is successful',
      () async {
        when(
          mockProductMgtRemoteDataSource.getProduct(tId),
        ).thenAnswer((_) async => tproductModel);

        final result = await repository.getProduct(tId);

        verify(mockProductMgtRemoteDataSource.getProduct(tId));
        expect(result, equals(Right(tproduct)));
      },
    );
    test(
      'getProduct - should return ServerFailure when the call to remote data source is unsuccessful',
      () async {
        when(
          mockProductMgtRemoteDataSource.getProduct(tId),
        ).thenThrow(ServerException());
        final result = await repository.getProduct(tId);
        verify(mockProductMgtRemoteDataSource.getProduct(tId));
        expect(result, equals(Left(ServerFailure())));
      },
    );
    test(
      'insertProduct - should insert product via remote data source and cache it locally on success',
      () async {
        when(
          mockProductMgtRemoteDataSource.insertProduct(tproductModel),
        ).thenAnswer((_) async => tproductModel);
        when(
          mockProductMgtLocalDataSource.cacheSingleProduct(tproductModel),
        ).thenAnswer((_) async => {});

        final result = await repository.insertProduct(tproduct);

        verify(mockProductMgtRemoteDataSource.insertProduct(tproductModel));
        verify(mockProductMgtLocalDataSource.cacheSingleProduct(tproductModel));
        expect(result, equals(Right(tproductModel)));
      },
    );

    test(
      'insertProduct - should return ServerFailure when remote data source throws ServerException',
      () async {
        when(
          mockProductMgtRemoteDataSource.insertProduct(any),
        ).thenThrow(ServerException());
        final result = await repository.insertProduct(tproduct);
        verify(mockProductMgtRemoteDataSource.insertProduct(any));
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'insertProduct - should return CacheFailure when caching throws CacheException',
      () async {
        when(
          mockProductMgtRemoteDataSource.insertProduct(any),
        ).thenAnswer((_) async => tproductModel);
        when(
          mockProductMgtLocalDataSource.cacheSingleProduct(any),
        ).thenThrow(CacheException());

        final result = await repository.insertProduct(tproduct);
        verify(mockProductMgtRemoteDataSource.insertProduct(any));
        verify(mockProductMgtLocalDataSource.cacheSingleProduct(any));
        expect(result, equals(Left(CacheFailure())));
      },
    );

    test(
      'updateProduct - should update product via remote data source and cache it locally on success',
      () async {
        when(
          mockProductMgtRemoteDataSource.updateProduct(any),
        ).thenAnswer((_) async => tproductModel);
        when(
          mockProductMgtLocalDataSource.cacheSingleProduct(any),
        ).thenAnswer((_) async => {});

        final result = await repository.updateProduct(tproduct);

        verify(mockProductMgtRemoteDataSource.updateProduct(any));
        verify(mockProductMgtLocalDataSource.cacheSingleProduct(any));
        expect(result, equals(Right(tproductModel)));
      },
    );
    test(
      'updateProduct - should return ServerFailure when remote data source throws ServerException',
      () async {
        when(
          mockProductMgtRemoteDataSource.updateProduct(any),
        ).thenThrow(ServerException());

        final result = await repository.updateProduct(tproduct);

        verify(mockProductMgtRemoteDataSource.updateProduct(any));
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'updateProduct - should return CacheFailure when caching throws CacheException',
      () async {
        when(
          mockProductMgtRemoteDataSource.updateProduct(any),
        ).thenAnswer((_) async => tproductModel);
        when(
          mockProductMgtLocalDataSource.cacheSingleProduct(any),
        ).thenThrow(CacheException());

        final result = await repository.updateProduct(tproduct);

        verify(mockProductMgtRemoteDataSource.updateProduct(any));
        verify(mockProductMgtLocalDataSource.cacheSingleProduct(any));
        expect(result, equals(Left(CacheFailure())));
      },
    );

    test(
      'getAllProducts - should return products when the call to remote data source is successful',
      () async {
        when(
          mockProductMgtRemoteDataSource.getAllProducts(),
        ).thenAnswer((_) async => tProducts);
        when(
          mockProductMgtLocalDataSource.cacheProducts(any),
        ).thenAnswer((_) async => {});

        final result = await repository.getAllProducts();

        verify(mockProductMgtRemoteDataSource.getAllProducts());
        verify(mockProductMgtLocalDataSource.cacheProducts(any));
        expect(result, equals(Right(tProducts)));
      },
    );

    test(
      'getAllProducts - should return ServerFailure when the call to remote data source is unsuccessful',
      () async {
        when(
          mockProductMgtRemoteDataSource.getAllProducts(),
        ).thenThrow(ServerException());

        final result = await repository.getAllProducts();

        verify(mockProductMgtRemoteDataSource.getAllProducts());
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'getAllProducts - should return CacheFailure when caching throws CacheException',
      () async {
        when(
          mockProductMgtRemoteDataSource.getAllProducts(),
        ).thenAnswer((_) async => tProducts);
        when(
          mockProductMgtLocalDataSource.cacheProducts(any),
        ).thenThrow(CacheException());

        final result = await repository.getAllProducts();

        verify(mockProductMgtRemoteDataSource.getAllProducts());
        verify(mockProductMgtLocalDataSource.cacheProducts(any));
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });











  group('when the device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
      'delete - should return server Failure when the user is offline',
      () async {
        final result = await repository.deleteProduct(tId);
        verifyZeroInteractions(mockProductMgtRemoteDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );
    test(
      'getProduct - should return Product when the call to local data source is successful',
      () async {
        when(
          mockProductMgtLocalDataSource.getCachedSingleProduct(tId),
        ).thenAnswer((_) async => tproductModel);

        final result = await repository.getProduct(tId);
        verify(mockProductMgtLocalDataSource.getCachedSingleProduct(tId));
        expect(result, equals(Right(tproduct)));
      },
    );

    test(
      'getProduct - should return CacheFailure when the call to local data source is unsuccessful',
      () async {
        when(
          mockProductMgtLocalDataSource.getCachedSingleProduct(tId),
        ).thenThrow(CacheException());
        final result = await repository.getProduct(tId);
        verify(mockProductMgtLocalDataSource.getCachedSingleProduct(tId));
        expect(result, equals(Left(CacheFailure())));
      },
    );

    test(
      'insertProduct - should return ServerFailure when device is offline',
      () async {
        final result = await repository.insertProduct(tproduct);
        verifyZeroInteractions(mockProductMgtRemoteDataSource);
        verifyZeroInteractions(mockProductMgtLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'updateProduct - should return ServerFailure when device is offline',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await repository.updateProduct(tproduct);

        verifyZeroInteractions(mockProductMgtRemoteDataSource);
        verifyZeroInteractions(mockProductMgtLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );

    test(
      'getAllProducts - should return products from local data source when the call is successful',
      () async {
        when(
          mockProductMgtLocalDataSource.getCachedProducts(),
        ).thenAnswer((_) async => tProducts);

        final result = await repository.getAllProducts();

        verify(mockProductMgtLocalDataSource.getCachedProducts());
        expect(result, equals(Right(tProducts)));
      },
    );

    test(
      'getAllProducts - should return CacheFailure when the call to local data source is unsuccessful',
      () async {
        when(
          mockProductMgtLocalDataSource.getCachedProducts(),
        ).thenThrow(CacheException());

        final result = await repository.getAllProducts();

        verify(mockProductMgtLocalDataSource.getCachedProducts());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
}
