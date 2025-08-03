
import 'package:dartz/dartz.dart';
import '../core/error/failures.dart';
class InputConverter {
  Either<Failure, double> stringToDouble(String str){
    try{
      final number = double.parse(str);
      if (number < 0){
        throw const FormatException();}
      return Right(number);
      } on FormatException{
        throw InvalidInputFailure();
      }
    }
  }


class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}