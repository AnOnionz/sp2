import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'customer_entity.g.dart';

@HiveType(typeId: 4)
// ignore: must_be_immutable
class CustomerEntity extends Equatable with HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String gender;
  @HiveField(2)
  String phoneNumber;
  @HiveField(3)
  String uuid;
  @HiveField(4)
  int deviceCreatedAt;
  @HiveField(5)
  int inTurn;
  @HiveField(6)
  int inSBTurn;

  CustomerEntity({this.name, this.gender, this.phoneNumber, this.inTurn, this.inSBTurn}) {
    var uUid = Uuid();
    uuid = uUid.v1(options: {
      'node': [0x22, 0x17, 0x09, 0x19, 0x98, 0xab],
      'clockSeq': 0x1234,
      'mSecs': DateTime.now().millisecondsSinceEpoch ~/1000,
      'nSecs': Random().nextInt(9999)
    });
    gender = gender ?? '1';
  }

  Map<String, dynamic> toCacheJson(){
    return {
      'name': name,
      'gender': gender,
      'phone': phoneNumber,
      'inTurn': inTurn,
      'inSBTurn': inSBTurn,
    };
  }
  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'phone': phoneNumber,
      'device_created_at': deviceCreatedAt,
      'gender': gender,
      'uuid': uuid,
    };
  }
  factory CustomerEntity.fromJson(Map<String, dynamic> json){
    return CustomerEntity(
      name: json['name'],
      phoneNumber: json['phone'],
      gender: json['gender'],
      inTurn: json['inTurn'],
      inSBTurn: json['inSBTurn']
    );
  }


  @override
  String toString() {
    return 'CustomerEntity{name: $name, gender: $gender, phoneNumber: $phoneNumber, uuid: $uuid, deviceCreatedAt: $deviceCreatedAt, inTurn: $inTurn, inSBTurn: $inSBTurn}';
  }

  @override
  List<Object> get props => [phoneNumber, inTurn, inSBTurn];

}