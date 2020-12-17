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
  final int tab;
  @HiveField(3)
  final String screen;

  FcmEntity({this.title, this.body, this.tab, this.screen});

  @override
  List<Object> get props => [title, body, tab, screen];

  @override
  String toString() {
    return 'FcmEntity{title: $title, body: $body, tab: $tab, screen: $screen}';
  }
}