import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/app/bloc/app_bloc.dart';
import 'package:innowatt/app/router/router.dart';
import 'package:innowatt/theme/theme.dart';
import 'package:innowatt/theme/util.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        )..add(const AppUserSubscriptionRequested()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Innowatt',
      theme: theme.dark(),
      routerConfig: router(context.read<AuthenticationRepository>().user),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
            onPressed: context.read<AuthenticationRepository>().logOut,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const Text('...in progress'),
    );
  }
}
