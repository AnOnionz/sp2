part of 'highlight_bloc.dart';

@immutable
abstract class HighlightState {}

class HighlightInitial extends HighlightState {}
class HighlightLoading extends HighlightState {}
class HighlightUpdated extends HighlightState {}
class HighlightFailure extends HighlightState {
  final String message;

  HighlightFailure({this.message});

}
class HighlightCached extends HighlightState {}
class HighlightCloseDialog extends HighlightState {}
class HighlightClear extends HighlightState {}
class HighlightNoContent extends HighlightState {
  final String message;

  HighlightNoContent({this.message});
}
class HighlightNoImage extends HighlightState {}