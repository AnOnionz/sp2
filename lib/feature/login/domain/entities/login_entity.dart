import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String accessToken;
  final String address;
  final String spName;
  final String spSDT;
  final String begin;
  final String end;
  final int turn;
  final String province;
  final int startPromotion;
  final int endPromotion;

  LoginEntity({this.code, this.turn, this.id, this.name, this.accessToken, this.address, this.spName, this.spSDT, this.begin, this.end, this.province,this.startPromotion,this.endPromotion});

  Map<String, dynamic> toJson() => {
    'id' : id ,
    'outlet_name': name ,
    'code': code ,
    'access_token' : accessToken ,
    'address' : address ,
    'sp_name' : spName ,
    'sp_phone' : spSDT ,
    'turns': turn ,
    'begin_working' : begin,
    'end_working': end,
    'province_name' : province ,
    'start_promotion_day':startPromotion,
    'end_promotion_day':endPromotion,
  };

  @override
  List<Object> get props => [id, name, code, accessToken, address, spName, spSDT, turn, begin, end, province, startPromotion, endPromotion];

  @override
  String toString() {
    return 'LoginEntity{id: $id, name: $name, code: $code, accessToken: $accessToken, address: $address, spName: $spName, spSDT: $spSDT, begin: $begin, end: $end, turn: $turn, province: $province, startPromotion: $startPromotion, endPromotion: $endPromotion}';
  }
}