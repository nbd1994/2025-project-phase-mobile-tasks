import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_mgt_repository.dart';

class GetProduct extends UseCase<Product, Params>{
  final ProductMgtRepository productMgtRepository;
  GetProduct(this.productMgtRepository);

  @override
  Future<Either<Failure, Product>> call(Params params) async {
    return await productMgtRepository.getProduct(params.id);
  }
}

class Params extends Equatable{
  final String id;
  const Params({required this.id});

  @override
  List<Object?> get props => [id];
  
}