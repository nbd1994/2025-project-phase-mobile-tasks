import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  const Failure([List properties = const <dynamic>[]]);
}

class DataSourceNotFoundFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ProductNotFoundFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}