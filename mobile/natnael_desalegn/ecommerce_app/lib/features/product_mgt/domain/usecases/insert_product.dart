import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_mgt_repository.dart';

class InsertProduct extends UseCase <Product, Params>{
  ProductMgtRepository productMgtRepository;
  InsertProduct(this.productMgtRepository);

  @override
  Future<Either<Failure, Product>> call(Params params) async{
    return await productMgtRepository.insertProduct(params.product);
  }
}

class Params extends Equatable{
  final Product product;

  const Params({required this.product});
  
  @override
  List<Object?> get props => [product];
}