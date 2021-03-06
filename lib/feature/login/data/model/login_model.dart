import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {

  LoginModel({int id,
  String name,
    String code,
    String accessToken,
  String address,
  String spName,
  String spSDT,
    int turn,
  String begin,
    String end,
  String province,
  int startPromotion,
    int endPromotion,
  }): super(id: id, name: name, code: code, accessToken: accessToken, address: address, spName: spName, spSDT: spSDT, turn : turn,begin: begin, end: end, province: province, startPromotion: startPromotion, endPromotion: endPromotion);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as int,
      name: json['outlet_name'],
      code: json['code'],
      accessToken: json['access_token'],
      address: json['address'],
      spName: json['sp_name'],
      spSDT: json['sp_phone'],
      turn: json['turns'] ,
      begin: json['begin_working'],
      end: json['end_working'],
      province: json['province_name'],
      startPromotion: json['start_promotion_day'],
      endPromotion: 1612803599
    );
  }

  @override
  List<Object> get props => [id, name, code, accessToken, address, spName, spSDT, turn, begin, end, province, startPromotion, endPromotion];
}