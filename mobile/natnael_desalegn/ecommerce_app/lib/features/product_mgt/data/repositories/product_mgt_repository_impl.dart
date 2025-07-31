import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_mgt_repository.dart';
import '../datasources/product_mgt_local_data_source.dart';

class ProductMgtRepositoryImpl implements ProductMgtRepository{

  ProductMgtLocalDataSource productMgtLocalDataSouce;
  ProductMgtRepositoryImpl({required this.productMgtLocalDataSouce});
  @override
  Future<Either<Failure, void>> deleteProduct(int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Product>> insertProduct(Product product) {
    // TODO: implement insertProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}