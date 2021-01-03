import 'package:hive/hive.dart';

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

  HighlightCacheEntity({this.workContent, this.rivalContent, this.posmContent, this.giftContent, this.workImages, this.rivalImages, this.posmImages, this.giftImages});


  Map<String, dynamic> toJson(){
    return {
    'work_text': workContent,
    'rival_text': rivalContent,
    'posm_text': posmContent,
    'gift_text': giftContent,
    'work_files': workImages,
    'rival_files': rivalImages,
    'posm_files': posmImages,
    'gift_files': giftImages,
      
    };
  }

}