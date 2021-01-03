part of 'tab_bloc.dart';

@immutable
abstract class TabState extends Equatable{

  const TabState();
  @override
  List<Object> get props => [];
}

class TabInitial extends TabState {}
class TabChanged extends TabState {
  final int index;

  TabChanged({this.index});

  @override
  List<Object> get props => [index];

}
