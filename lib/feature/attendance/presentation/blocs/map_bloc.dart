import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:equatable/equatable.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial());
  static LocationData position;

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is MapStarted) {
      if (position != null) {
        yield MapLoaded(position: position);
      } else {
        yield MapLoading();
        try {
          Location location = new Location();
          position = await location.getLocation();
          if (position != null) {
            yield MapLoaded(position: position);
          } else {
            yield MapFailed();
          }
        } catch (e, s) {
          print(e);
          print(s);
          yield MapFailed();
        }
      }
    }
  }

  @override
  void onTransition(Transition<MapEvent, MapState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
