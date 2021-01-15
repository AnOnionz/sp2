import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

part 'highlight_cache_entity.g.dart';

@HiveType(typeId: 1)
class HighlightCacheEntity extends HiveObject{
  @HiveField(0)
  final String workContent;
  @HiveField(1)
  final String rivalContent;
  @HiveField(2)
  final String posmContent;
  @HiveField(3)
  final String giftContent;
  @HiveField(4)
  final List<String> workImages;
  @HiveField(5)
  final List<String> rivalImages;
  @HiveField(6)
  final List<String> posmImages;
  @HiveField(7)
  final List<String> giftImages;
  @HiveField(8)
  final String outletCode;

  HighlightCacheEntity({this.outletCode, this.workContent, this.rivalContent, this.posmContent, this.giftContent, this.workImages, this.rivalImages, this.posmImages, this.giftImages});


  @override
  String toString() {
    return 'HighlightCacheEntity{workContent: $workContent, rivalContent: $rivalContent, posmContent: $posmContent, giftContent: $giftContent, workImages: $workImages, rivalImages: $rivalImages, posmImages: $posmImages, giftImages: $giftImages, outletCode: $outletCode,}';
  }

  factory HighlightCacheEntity.fromJson(Map<String, dynamic> json){
    return json == null ? null : HighlightCacheEntity(
      workContent: json['work_text'],
      workImages: json['work_files'],
      rivalContent: json['rival_text'],
      rivalImages: json['rival_files'],
      posmContent: json['gift_text'],
      posmImages: json['posm_files'],
      giftContent: json['gift_text'],
      giftImages: json['gift_files'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'outlet_code': outletCode,
    'work_text': workContent,
    'rival_text': rivalContent,
    'posm_text': posmContent,
    'gift_text': giftContent,
    'work_files': workImages.map((e) =>
        MultipartFile.fromFileSync(
          e, filename: basename(e),
        ),).toList(),
    'rival_files': rivalImages.map((e) =>
        MultipartFile.fromFileSync(
          e, filename: basename(e),
        ),).toList(),
    'posm_files': posmImages.map((e) =>
        MultipartFile.fromFileSync(
          e, filename: basename(e),
        ),).toList(),
    'gift_files':giftImages.map((e) =>
        MultipartFile.fromFileSync(
          e, filename: basename(e),
        ),).toList(),
      
    };
  }

}