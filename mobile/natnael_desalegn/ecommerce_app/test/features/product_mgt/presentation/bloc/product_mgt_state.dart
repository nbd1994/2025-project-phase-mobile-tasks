part of 'product_mgt_bloc.dart';

abstract class ProductMgtState extends Equatable {
  const ProductMgtState();  

  @override
  List<Object> get props => [];
}
class ProductMgtInitial extends ProductMgtState {}
