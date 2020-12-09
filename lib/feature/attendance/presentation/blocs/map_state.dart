part of 'map_bloc.dart';

@immutable
abstract class MapState extends Equatable {
  const MapState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class MapInitial extends MapState {}

class MapLoading extends MapState {}

// ignore: must_be_immutable
class MapLoaded extends MapState {
  LocationData position;

  MapLoaded({this.position});
  @override
  // TODO: implement props
  List<Object> get props => [position];
}

class MapFailed extends MapState {}
