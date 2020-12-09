import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HighlightEntity extends Equatable{
  String title;
  String content;
  TextEditingController controller = TextEditingController();
  List<File> images;

  HighlightEntity(this.title, this.content, this.images);

  @override
  List<Object> get props => [title, content, images, controller];
}