import 'package:dartz/dartz.dart';

import '../../../../core/entities/product.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../repositories/product_mgt_repository.dart';
import 'insert_product.dart';

class UpdateProduct extends UseCase <Product, Params> {
  ProductMgtRepository productMgtRepository;
  UpdateProduct(this.productMgtRepository);

  @override
  Future<Either<Failure, Product>> call(Params params) async{
    return await productMgtRepository.updateProduct(params.product);
  }
}