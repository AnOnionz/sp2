import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String id;
  final String name;
  final String accessToken;
  final String address;
  final String srName;
  final String srSDT;
  final String time;
  final String province;

  LoginEntity({this.id, this.name, this.accessToken, this.address, this.srName, this.srSDT, this.time, this.province});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'access_token' : accessToken,
    'address' : address,
    'sr_name' : srName,
    'sr_sdt' : srSDT,
    'time' : time,
    'province' : province,
  };

  @override
  List<Object> get props => [id];


  @override
  String toString() {
    return 'LoginEntity{id: $id, name: $name, address: $address, srName: $srName, srSDT: $srSDT, time: $time, province: $province}';
  }
}