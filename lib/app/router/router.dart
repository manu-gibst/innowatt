import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/bloc/app_bloc.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/app/view/app.dart';
import 'package:innowatt/auth/login/view/login_page.dart';
import 'package:innowatt/auth/sign_up/view/sign_up_page.dart';
import 'package:innowatt/chat/view/all_chats_view.dart';
import 'package:innowatt/chat/view/create_new_chat.dart';
part 'scaffold_with_navbar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter router(AppBloc bloc) {
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
                builder: (context, state) => const AllChatsView(),
                path: Routes.chatRoutes.allChats,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                builder: (context, state) => const HomePage(),
                path: Routes.home,
              ),
              GoRoute(
                builder: (context, state) => const CreateNewChat(),
                path: Routes.chatRoutes.createNew,
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authenticated = bloc.state.status.isAuthenticated;
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
    refreshListenable: bloc,
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
