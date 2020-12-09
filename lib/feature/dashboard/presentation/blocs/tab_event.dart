part of 'tab_bloc.dart';

@immutable
abstract class TabEvent extends Equatable{

  const TabEvent();

  @override
  List<Object> get props => [];
}
class TabPressed extends TabEvent{
  final Widget child;
  final int index;

  TabPressed(this.child, {this.index});
  @override
  List<Object> get props => [index];
}

