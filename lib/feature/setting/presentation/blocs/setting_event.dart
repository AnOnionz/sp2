part of 'setting_bloc.dart';

@immutable
abstract class SettingEvent {}
class SettingStart extends SettingEvent {}
class CheckVersion extends SettingEvent {
}
class UpdateApp extends SettingEvent {}

