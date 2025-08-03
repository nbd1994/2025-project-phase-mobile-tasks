part of 'product_mgt_bloc.dart';

sealed class ProductMgtState extends Equatable {
  const ProductMgtState();

  @override
  List<Object> get props => [];
}

final class ProductMgtInitialState extends ProductMgtState {}

final class ProductMgtLoadingState extends ProductMgtState {}

final class ProductMgtAllProductsLoadedState extends ProductMgtState {
  final List<Product> products;
  const ProductMgtAllProductsLoadedState(this.products);
  @override
  List<Object> get props => [products];
}

final class ProductMgtSingleProductLoadedState extends ProductMgtState {
  final Product product;
  const ProductMgtSingleProductLoadedState(this.product);

  @override
  List<Object> get props => [product];
}

final class ProductMgtErrorState extends ProductMgtState {
  final String message;
  const ProductMgtErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
