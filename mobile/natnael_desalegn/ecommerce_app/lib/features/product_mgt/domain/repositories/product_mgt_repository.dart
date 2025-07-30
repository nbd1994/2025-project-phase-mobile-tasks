import 'package:dartz/dartz.dart';

import '../../../../core/entities/product.dart';
import '../../../../core/error/failures.dart';

abstract class ProductMgtRepository {
  Future<Either<Failure, Product>> getProduct(int id);
  Future<Either<Failure, Product>> insertProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(int id);
}
