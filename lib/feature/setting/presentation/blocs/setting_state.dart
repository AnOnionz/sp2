part of 'setting_bloc.dart';

@immutable
abstract class SettingState {}

class SettingInitial extends SettingState {}
class SettingLoaded extends SettingState {
  final PackageInfo packageInfo;

  SettingLoaded({this.packageInfo});
}
class RequireUpdateApp extends SettingState {
  final PackageInfo packageInfo;
  final UpdateEntity updateEntity;

  RequireUpdateApp({this.packageInfo, this.updateEntity});
}
class NoRequireUpdateApp extends SettingState {}
