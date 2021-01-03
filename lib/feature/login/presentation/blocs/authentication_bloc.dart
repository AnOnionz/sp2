import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:sp_2021/core/common/keys.dart';
import 'package:sp_2021/core/platform/network_info.dart';
import 'package:sp_2021/core/storage/secure_storage.dart';
import 'package:sp_2021/feature/dashboard/domain/entities/today_data_entity.dart';
import 'package:sp_2021/feature/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:sp_2021/feature/login/domain/entities/login_entity.dart';
import 'package:sp_2021/feature/receive_gift/domain/entities/customer_entity.dart';

import '../../../../di.dart';
import '../../../../my_application.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SecureStorage storage;
  static LoginEntity outlet;
  AuthenticationBloc({@required this.storage}) : super(AuthenticationInitial());
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        // user from login success
        outlet = await storage.readOutlet(key: OUTLET_IN_STORAGE);
        print('OUTLET:' + outlet.toString());
        if (outlet != null) {
          Future.delayed(Duration.zero);
          yield AuthenticationAuthenticated(outlet: outlet);
        } else {
          yield AuthenticationUnauthenticated();
        }
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      storage.writeOutlet(key: OUTLET_IN_STORAGE, value: event.loginEntity);
      outlet = event.loginEntity;
      Future.delayed(Duration.zero);
      yield AuthenticationAuthenticated(outlet: event.loginEntity);
    }

    if (event is LoggedOut) {
      storage.delete(key: OUTLET_IN_STORAGE);
      yield AuthenticationUnauthenticated();
    }
    if (event is ShutDown) {
      yield AuthenticationDuplicated(willPop: event.willPop);
    }
  }

}
