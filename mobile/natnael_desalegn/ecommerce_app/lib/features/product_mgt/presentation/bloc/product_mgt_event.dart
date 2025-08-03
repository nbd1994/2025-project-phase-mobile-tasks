part of 'product_mgt_bloc.dart';

sealed class ProductMgtEvent extends Equatable {
  const ProductMgtEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProductEvent extends ProductMgtEvent {}

class GetSingleProductEvent extends ProductMgtEvent {
  final int id;
  const GetSingleProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateProductEvent extends ProductMgtEvent {
  final Product product;
  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductMgtEvent {
  final int id;
  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProductEvent extends ProductMgtEvent {
  final Product product;
  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}