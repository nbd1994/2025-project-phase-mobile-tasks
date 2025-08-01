import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_mgt_repository.dart';

class GetAllProducts extends UseCase<List<Product>, NoParams>{
  final ProductMgtRepository productMgtRepository;
  GetAllProducts(this.productMgtRepository);
  @override
  Future<Either<Failure, List<Product>>> call(NoParams params)async {
    return await productMgtRepository.getAllProducts();
  }

}