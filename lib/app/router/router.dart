import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/bloc/app_bloc.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/app/view/app.dart';
import 'package:innowatt/login/view/login_page.dart';
import 'package:innowatt/sign_up/view/sign_up_page.dart';
part 'scaffold_with_navbar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter router(Stream<dynamic> stream) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.login,
    routes: <RouteBase>[
      GoRoute(
        builder: (context, state) => const LoginPage(),
        path: Routes.login,
      ),
      GoRoute(
        builder: (context, state) => const SignUpPage(),
        path: Routes.signUp,
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ScaffoldWithNavbar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                builder: (context, state) => const HomePage(),
                path: Routes.home,
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authenticated =
          context.watch<AppBloc>().state.status.isAuthenticated;
      final onLoginPage = state.matchedLocation == Routes.login;
      final onSignUpPage = state.matchedLocation == Routes.signUp;

      if (!authenticated) {
        return !onSignUpPage ? Routes.login : null;
      }
      if (onLoginPage) {
        return Routes.home;
      }
      return null;
    },
    refreshListenable: StreamListenable(stream),
  );
}

extension on AppStatus {
  bool get isAuthenticated => this == AppStatus.authenticated;
}

class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic change) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
