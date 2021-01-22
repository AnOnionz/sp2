part of 'setting_bloc.dart';

@immutable
abstract class SettingState {}

class SettingInitial extends SettingState {}
class RequireUpdateApp extends SettingState {
  final UpdateEntity updateEntity;

  RequireUpdateApp({this.updateEntity});
}
class NoRequireUpdateApp extends SettingState {}
