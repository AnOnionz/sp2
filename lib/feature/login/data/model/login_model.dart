import 'package:equatable/equatable.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {

  LoginModel({int id,
  String name,
    String code,
    String accessToken,
  String address,
    String srCode,
  String srName,
  String srSDT,
    int turn,
  String time,
  String province}): super(id: id, name: name, code: code, accessToken: accessToken, address: address, spCode: srCode, spName: srName, spSDT: srSDT, turn : turn, time: time , province: province);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as int ?? 0,
      name: json['outlet_name'] ?? "name",
      code: json['code'] ?? "code",
      accessToken: json['access_token'] ?? "",
      address: json['address'] ?? "0",
      srCode: json['sr_code'] ?? "0",
      srName: json['sr_name'] ??"0",
      srSDT: json['sr_sdt'] ??"0",
      turn: json['turn'] as int ?? 5,
      time: json['time'] ?? "0",
      province: json['province'] ?? "HCM"

    );
  }

  @override
  List<Object> get props => [id, name, code, accessToken, address, spCode, spName, spSDT, turn, time, province];
}