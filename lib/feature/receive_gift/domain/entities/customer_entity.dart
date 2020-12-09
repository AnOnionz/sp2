import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String name;
  final String phoneNumber;
  final int inTurn;

  CustomerEntity({this.name, this.phoneNumber, this.inTurn});

  CustomerEntity copyWith({int turn}){
        return CustomerEntity(name: this.name, phoneNumber: this.phoneNumber, inTurn: turn ?? this.inTurn );
  }

  @override
  List<Object> get props => [phoneNumber];

}