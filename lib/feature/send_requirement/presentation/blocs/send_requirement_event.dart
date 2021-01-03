part of 'send_requirement_bloc.dart';

@immutable
abstract class SendRequirementEvent {}
class SendRequirement extends SendRequirementEvent {
  final String message;

  SendRequirement({this.message});
}