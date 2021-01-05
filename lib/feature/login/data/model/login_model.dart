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
      id: json['id'] as int ?? 12345,
      name: json['outlet_name'] ?? "Outlet Name",
      code: json['code'] ?? "jh179",
      accessToken: json['access_token'] ?? "",
      address: "HCM",//json['address']
      srCode: json['sr_code'] ?? "1357",
      srName: json['sr_name'] ??"Nguyễn Văn Thị",
      srSDT: json['sr_sdt'] ??"0933123321",
      turn: json['turn'] as int ?? 5,
      time: json['time'] ?? "6h-11h",
      province: json['province'] ?? "HCM"
    );
  }

  @override
  List<Object> get props => [id, name, code, accessToken, address, spCode, spName, spSDT, turn, time, province];
}