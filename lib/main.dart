// import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:innowatt/constants/routes.dart';
import 'package:innowatt/services/auth/auth_service.dart';
import 'package:innowatt/theme/theme.dart';
import 'package:innowatt/theme/util.dart';
import 'package:innowatt/views/chats/all_chats_view.dart';
import 'package:innowatt/views/chats/create_new_chat.dart';
import 'package:innowatt/views/login_view.dart';
import 'package:innowatt/views/register_view.dart';
import 'package:innowatt/views/verify_email_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Innowatt',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      darkTheme: theme.dark(),
      home: const HomePage(),
      routes: {
        // loginRoute: (context) => const LoginView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        chatsListViewRoute: (context) => const AllChatsView(),
        createNewChatRoute: (context) => const CreateNewChat(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const AllChatsView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
