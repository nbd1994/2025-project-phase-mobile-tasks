import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_mgt_repository.dart';
import '../datasources/product_mgt_local_data_source.dart';
import '../datasources/product_mgt_remote_data_source.dart';
import '../models/product_model.dart';

class ProductMgtRepositoryImpl implements ProductMgtRepository {
  ProductMgtRemoteDataSource productMgtRemoteDataSouce;
  ProductMgtLocalDataSource productMgtLocalDataSource;
  NetworkInfo networkInfo;
  ProductMgtRepositoryImpl({
    required this.productMgtRemoteDataSouce,
    required this.productMgtLocalDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, Product>> deleteProduct(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final deletedProduct = await productMgtRemoteDataSouce.deleteProduct(
          id,
        );
        await productMgtLocalDataSource.deleteCachedProduct(deletedProduct);
        return Right(deletedProduct);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final pdt = await productMgtRemoteDataSouce.getProduct(id);
        return Right(pdt);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final pdt = await productMgtLocalDataSource.getCachedSingleProduct(id);
        return Right(pdt);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> insertProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
        );
        final insertedProduct = await productMgtRemoteDataSouce.insertProduct(
          productModel,
        );
        await productMgtLocalDataSource.cacheSingleProduct(insertedProduct);
        return Right(insertedProduct);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
        );
        final updatedProduct = await productMgtRemoteDataSouce.updateProduct(
          productModel,
        );
        await productMgtLocalDataSource.cacheSingleProduct(updatedProduct);
        return Right(updatedProduct);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await productMgtRemoteDataSouce.getAllProducts();
        await productMgtLocalDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      try {
        final products = await productMgtLocalDataSource.getCachedProducts();
        return Right(products);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
