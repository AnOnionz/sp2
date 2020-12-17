import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
part 'highlight_entity.g.dart';

@HiveType(typeId: 1)
class HighlightEntity extends Equatable with HiveObject{
  @HiveField(0)
  final String title;
  final String hint;
  @HiveField(1)
  String content;
  @HiveField(2)
  List<File> images;
  TextEditingController controller = TextEditingController();

  HighlightEntity({this.title, this.content, this.images, this.hint});

  HighlightEntity copyWith({String content, List<File> images}){
    return HighlightEntity(title: this.title, hint: this.hint, content: content ?? this.content, images: images ?? this.images);

  }

  @override
  List<Object> get props => [title, content, images, controller];
}