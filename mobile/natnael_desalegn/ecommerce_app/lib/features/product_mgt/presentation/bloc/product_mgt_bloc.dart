// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../utils/input_converter.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_product.dart' as get_product;
import '../../domain/usecases/insert_product.dart' as insert_product;
import '../../domain/usecases/update_product.dart';

part 'product_mgt_event.dart';
part 'product_mgt_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive float or zero.';

String _mapFailureToMessage(Failure failure) {
  // Instead of a regular 'if (failure is ServerFailure)...'
  switch (failure.runtimeType) {
    case ServerFailure _:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure _:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}

// ProductMgtState _eitherLoadedOrErrorState(result) {
//   return result.fold(
//     (failure) => ProductMgtErrorState(message: _mapFailureToMessage(failure)),
//     (res) => res is List<Product> ? ProductMgtAllProductsLoadedState(res) : ProductMgtSingleProductLoadedState(res),
//   );
// }

class ProductMgtBloc extends Bloc<ProductMgtEvent, ProductMgtState> {
  insert_product.InsertProduct insertProduct;
  DeleteProduct deleteProduct;
  UpdateProduct updateProduct;
  get_product.GetProduct getProduct;
  GetAllProducts getAllProducts;
  InputConverter inputConverter;
  ProductMgtBloc({
    required this.insertProduct,
    required this.deleteProduct,
    required this.updateProduct,
    required this.getAllProducts,
    required this.getProduct,
    required this.inputConverter,
  }) : super(ProductMgtInitialState()) {
    //Get single Product
    on<GetSingleProductEvent>((event, emit) async {
      emit(ProductMgtLoadingState());
      final result = await getProduct(get_product.Params(id: event.id));

      result.fold(
        (failure) =>
            emit(ProductMgtErrorState(message: _mapFailureToMessage(failure))),
        (product) => emit(ProductMgtSingleProductLoadedState(product)),
      );
    });

    //get all Products
    on<LoadAllProductEvent>((event, emit) async {
      emit(ProductMgtLoadingState());
      final result = await getAllProducts(NoParams());
      result.fold(
        (failure) =>
            emit(ProductMgtErrorState(message: _mapFailureToMessage(failure))),
        (products) => emit(ProductMgtAllProductsLoadedState(products)),
      );
    });

    //create product
    on<CreateProductEvent>((event, emit) async {
      emit(ProductMgtLoadingState());
      final result = await insertProduct(
        insert_product.Params(product: event.product),
      );
      result.fold(
        (failure) =>
            emit(ProductMgtErrorState(message: _mapFailureToMessage(failure))),
        (_) => add(LoadAllProductEvent()), // Reload all products after creation
      );
    });

    // Update product
    on<UpdateProductEvent>((event, emit) async {
      emit(ProductMgtLoadingState());
      final result = await updateProduct(
        insert_product.Params(product: event.product),
      );
      result.fold(
        (failure) =>
            emit(ProductMgtErrorState(message: _mapFailureToMessage(failure))),
        (_) => add(LoadAllProductEvent()), // Reload all products after update
      );
    });

    // Delete product
    on<DeleteProductEvent>((event, emit) async {
      emit(ProductMgtLoadingState());
      final result = await deleteProduct(get_product.Params(id: event.id));
      result.fold(
        (failure) =>
            emit(ProductMgtErrorState(message: _mapFailureToMessage(failure))),
        (_) => add(LoadAllProductEvent()), // Reload all products after delete
      );
    });
  }
}