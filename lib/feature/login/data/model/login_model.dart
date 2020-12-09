import 'package:equatable/equatable.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {

  LoginModel({String id,
  String name,
    String accessToken,
  String address,
  String srName,
  String srSDT,
  String time,
  String province}): super(id: id, name: name, accessToken: accessToken, address: address, srName: srName, srSDT: srSDT,time: time , province: province);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] ,
      name: json['name'],
      accessToken: json['access_token'],
      address: json['address'],
      srName: json['sr_name'],
      srSDT: json['sr_sdt'],
      time: json['time'],
      province: json['province']

    );
  }

  @override
  List<Object> get props => [id];
}