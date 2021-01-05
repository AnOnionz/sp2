import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String accessToken;
  final String address;
  final String spCode;
  final String spName;
  final String spSDT;
  final String time;
  final int turn;
  final String province;

  LoginEntity({this.code, this.turn, this.id, this.name, this.accessToken, this.address,this.spCode, this.spName, this.spSDT, this.time, this.province});

  Map<String, dynamic> toJson() => {
    'id' : id ,
    'name': name ,
    'code': code ,
    'access_token' : accessToken ,
    'address' : address ,
    'sr_code': spCode,
    'sr_name' : spName ,
    'sr_sdt' : spSDT ,
    'turn': turn ,
    'time' : time ,
    'province' : province ,
  };

  @override
  List<Object> get props => [id, name, code, accessToken, address, spCode, spName, spSDT, turn, time, province];

  @override
  String toString() {
    return 'LoginEntity{id: $id, name: $name, code: $code, accessToken: $accessToken, address: $address, spCode: $spCode, spName: $spName, spSDT: $spSDT, time: $time, turn: $turn, province: $province}';
  }
}