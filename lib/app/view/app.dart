import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innowatt/app/bloc/app_bloc.dart';
import 'package:innowatt/app/router/router.dart';
import 'package:innowatt/chat/single_user_chat/view/chat_list_builder.dart';
import 'package:innowatt/chat/single_user_chat/view/message_bubble.dart';
import 'package:innowatt/repository/message_repository/src/models/message.dart';
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
      routerConfig: router(context.watch<AppBloc>()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Message> tempMessages = [
      Message(
        authorId: 'otherId',
        createdAt: Timestamp.fromDate(DateTime(2024)),
        text: 'Hello, I am other',
      ),
      Message(
        authorId: 'authorId',
        createdAt: Timestamp.fromDate(DateTime(2024)),
        text: 'Hello, I am Manu',
      ),
      Message(
        authorId: 'authorId',
        createdAt: Timestamp.now(),
        text:
            'A week ago Miras from GDGC asked for my help to develop flutter app for 6k tenge (kinda small amount but i was here for fun).After a few days i collaborated with the team of 6 members (like 4 of them were active lol), and we created a really technically-solid project. ',
      ),
      Message(
        authorId: 'otherId',
        createdAt: Timestamp.now(),
        text: 'shut up',
      ),
      Message(
        authorId: 'otherId',
        createdAt: Timestamp.now(),
        text: 'Why are you telling me that',
      ),
      Message(
        authorId: 'authorId',
        createdAt: Timestamp.now(),
        text: 'А а в ы ылц у у у у цы в в уу к ее к у ы в в аа а у',
      ),
      Message(
        authorId: 'authorId',
        createdAt: Timestamp.now(),
        text: 'Воввововооавовоовововвовововгвгвововгвг',
      ),
      Message(
        authorId: 'authorId',
        createdAt: Timestamp.now(),
        text: 'Не обращай внимения. Я просто стою n',
      ),
    ];
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
