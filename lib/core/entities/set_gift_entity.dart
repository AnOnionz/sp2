import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'gift_entity.dart';
part 'set_gift_entity.g.dart';

@HiveType(typeId: 10)
class SetGiftEntity extends HiveObject{
  @HiveField(0)
  int index;
  @HiveField(1)
  List<GiftEntity> gifts;

  SetGiftEntity({this.index, this.gifts});

  factory SetGiftEntity.fromJson(Map<String, dynamic> json){
     return json != null ? SetGiftEntity(
       index: json['index'],
       gifts: (json['skus'] as List<dynamic>).map((e) => GiftEntity.fromJson(e)).toList(),
     ) : null;
  }
  Map<String, dynamic> toJson(){
    return {
      'index': index,
      'skus': gifts.map((e) => e.toJsonCurrent()).toList(),
    };
  }
  static List<SetGiftEntity> parseSetGift(Response response){
    List<Map<String, dynamic>> data = response.data['data'];
      return data.map((e) => SetGiftEntity.fromJson(e)).toList();
  }

  @override
  String toString() {
    return 'SetGiftEntity{index: $index, gifts: $gifts}';
  }
}