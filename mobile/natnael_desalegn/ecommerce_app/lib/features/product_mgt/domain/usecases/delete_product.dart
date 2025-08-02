import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_mgt_repository.dart';
import 'get_product.dart';

class DeleteProduct extends UseCase <Product, Params>{
  ProductMgtRepository productMgtRepository;
  DeleteProduct(this.productMgtRepository);

  @override
  Future<Either<Failure, Product>> call(Params params) async{
    return await productMgtRepository.deleteProduct(params.id);
  }
}