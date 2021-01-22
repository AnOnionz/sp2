import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class HighlightEntity extends Equatable with HiveObject{
  final String title;
  final String hint;
  String content;
  List<File> images;
  TextEditingController controller = TextEditingController();

  HighlightEntity({this.title, this.content, this.images, this.hint}){
    controller.text = content;
  }


  @override
  List<Object> get props => [title, content, images, controller];

  @override
  String toString() {
    return 'HighlightEntity{ title: $title, hint: $hint, content: $content, images: $images,}';
  }
}