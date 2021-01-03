part of 'highlight_bloc.dart';

@immutable
abstract class HighlightEvent {}
class HighlightUpToServer extends HighlightEvent{
  final List<HighlightEntity> highlights;

  HighlightUpToServer({this.highlights});
}
class HighlightValidateForm extends HighlightEvent{
  final List<HighlightEntity> highlights;

  HighlightValidateForm({this.highlights});
}
