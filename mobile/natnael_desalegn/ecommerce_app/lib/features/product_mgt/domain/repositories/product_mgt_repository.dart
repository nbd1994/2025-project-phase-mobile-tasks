import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductMgtRepository {
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, Product>> insertProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, Product>> deleteProduct(String id);
  Future<Either<Failure, List<Product>>> getAllProducts();
}
