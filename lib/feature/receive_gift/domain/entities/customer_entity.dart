import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:sp_2021/core/platform/date_time.dart';
import 'package:uuid/uuid.dart';
part 'customer_entity.g.dart';

@HiveType(typeId: 4)
class CustomerEntity extends Equatable with HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String phoneNumber;
  @HiveField(2)
  String uuid;
  @HiveField(3)
  int deviceCreatedAt;
  @HiveField(4)
  int inTurn;

  CustomerEntity({this.name, this.phoneNumber, this.inTurn,}) {
    var uUid = Uuid();
    uuid = uUid.v1(options: {
      'node': [0x22, 0x17, 0x09, 0x19, 0x98, 0xab],
      'clockSeq': 0x1234,
      'mSecs': DateTime.now().millisecondsSinceEpoch,
      'nSecs': int.parse(phoneNumber.substring(1,5)),
    });
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'phone': phoneNumber,
      'device_created_at': deviceCreatedAt,
      'uuid': uuid,
    };
  }


  @override
  String toString() {
    return 'CustomerEntity{name: $name, phoneNumber: $phoneNumber, uuid: $uuid, deviceCreatedAt: $deviceCreatedAt, inTurn: $inTurn}';
  }

  @override
  List<Object> get props => [phoneNumber];

}