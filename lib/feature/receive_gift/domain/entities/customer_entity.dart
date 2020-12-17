import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'customer_entity.g.dart';

@HiveType(typeId: 4)
class CustomerEntity extends Equatable with HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String phoneNumber;
  @HiveField(2)
  int inTurn;

  CustomerEntity({this.name, this.phoneNumber, this.inTurn});

  CustomerEntity copyWith({int turn}){
        return CustomerEntity(name: this.name, phoneNumber: this.phoneNumber, inTurn: turn ?? this.inTurn );
  }

  @override
  List<Object> get props => [phoneNumber];

}