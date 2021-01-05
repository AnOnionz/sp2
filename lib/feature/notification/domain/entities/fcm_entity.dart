import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'fcm_entity.g.dart';

@HiveType(typeId: 3)
class FcmEntity extends Equatable with HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final DateTime time;
  @HiveField(3)
  final int tab;
  @HiveField(4)
  final String screen;
  @HiveField(5)
  bool isClick;

  FcmEntity({this.title, this.body, this.time, this.tab, this.screen, this.isClick});

  @override
  List<Object> get props => [title, body, time, tab, screen, isClick];

  @override
  String toString() {
    return 'FcmEntity{title: $title, body: $body, time: $time, tab: $tab, screen: $screen, isClick: $isClick';
  }
}