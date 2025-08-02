import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductMgtRepository {
  Future<Either<Failure, Product>> getProduct(int id);
  Future<Either<Failure, Product>> insertProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, Product>> deleteProduct(int id);
  Future<Either<Failure, List<Product>>> getAllProducts();
}
