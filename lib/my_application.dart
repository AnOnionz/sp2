import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_2021/core/util/custom_dialog.dart';
import 'core/api/myDio.dart';
import 'package:sp_2021/feature/login/presentation/blocs/login_bloc.dart';
import 'di.dart';
import 'feature/attendance/presentation/blocs/map_bloc.dart';
import 'feature/login/presentation/blocs/authentication_bloc.dart';
import 'feature/dashboard/presentation/screens/dashboard.dart';
import 'feature/login/presentation/screens/login_page.dart';

class MyApplication extends StatelessWidget {
  const MyApplication();
  @override
  Widget build(BuildContext context) {
    print("build my application");
    // DIO REQUEST
    return MaterialApp(
        navigatorKey: sl<Dialogs>().navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (_) => sl<AuthenticationBloc>()..add(AppStarted()),
            ),
            BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
            BlocProvider<MapBloc>(create: (_) => sl<MapBloc>()),
          ],
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationLoading) {
                      return Scaffold(
                        body: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is AuthenticationUnauthenticated) {
                      return LoginPage(deviceId: "abc");
                    }
                    if (state is AuthenticationAuthenticated) {
                      sl<CDio>().setBearerAuth(state.user.accessToken);
                      return DashboardPage();
                    }
                    return Container(
                      color: Colors.white,
                    );
                  },
                )
        ));
  }
}
