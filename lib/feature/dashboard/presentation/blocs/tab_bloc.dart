import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/feature/dashboard/presentation/screens/home_page.dart';

part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(TabChanged(HomePage(), index: 0));

  @override
  Stream<TabState> mapEventToState(
    TabEvent event,
  ) async* {
    if(event is TabPressed){
      yield TabChanged(event.child, index: event.index);
    }
  }
  @override
  void onTransition(Transition<TabEvent, TabState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
