part of 'send_requirement_bloc.dart';

@immutable
abstract class SendRequirementState {}

class SendRequirementInitial extends SendRequirementState {}
class SendRequirementLoading extends SendRequirementState {}
class SendRequirementSuccess extends SendRequirementState {}
class SendRequirementCached extends SendRequirementState {}
class SendRequirementFailure extends SendRequirementState {
  final String message;

  SendRequirementFailure({this.message});
}