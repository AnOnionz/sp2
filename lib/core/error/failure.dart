import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
// ignore: must_be_immutable
abstract class Failure extends Equatable{
    String message ;
    Failure(mess) : message = mess;

    @override
  String toString() {
    return '$message';
  }
    @override
  List<Object> get props => [message];
}

// ignore: must_be_immutable
class ServerFailure extends Failure{
  ServerFailure({message}): super(message);

}
// ignore: must_be_immutable
class ResponseFailure extends Failure{
  ResponseFailure({message}): super(message);
}
