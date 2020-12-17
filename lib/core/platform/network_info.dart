import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
  Stream<DataConnectionStatus> get listener;
}
class NetworkInfoImpl extends NetworkInfo{
  final DataConnectionChecker _dataConnectionChecker;

  NetworkInfoImpl(this._dataConnectionChecker);
  @override
  Future<bool> get isConnected async => await _dataConnectionChecker.hasConnection;

  @override
  Stream<DataConnectionStatus> get listener => _dataConnectionChecker.onStatusChange;


}