import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_mgt_event.dart';
part 'product_mgt_state.dart';

class ProductMgtBloc extends Bloc<ProductMgtEvent, ProductMgtState> {
  ProductMgtBloc() : super(ProductMgtInitial()) {
    on<ProductMgtEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
