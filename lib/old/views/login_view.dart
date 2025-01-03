import 'package:flutter/material.dart';
import 'package:innowatt/old/components/button.dart';
import 'package:innowatt/old/components/spacings.dart';
import 'package:innowatt/old/components/text.dart';
import 'package:innowatt/old/components/text_field.dart';
import 'package:innowatt/constants/image_routes.dart';
import 'package:innowatt/constants/routes.dart';
import 'package:innowatt/old/services/auth/auth_exceptions.dart';
import 'package:innowatt/old/services/auth/auth_service.dart';
import 'package:innowatt/old/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      // backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LOGO AND TITLE -----------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoImage,
                height: 200,
              ),
              Expanded(
                child: MyText(
                  text: "Charge your business with InnoWatt!",
                  color: Colors.red,
                  // color: Theme.of(context).colorScheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // INPUTS --------------------------------------------------------
                MyTextField(
                  controller: _email,
                  hintText: "Email",
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                addVerticalSpace(15),
                MyTextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  hintText: "Password",
                ),
                addVerticalSpace(10),
                // BUTTON ------------------------------------------------------
                MyButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      if (context.mounted) {
                        if (user?.isEmailVerified ?? false) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            chatsListViewRoute,
                            (route) => false,
                          );
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute,
                            (route) => false,
                          );
                        }
                      }
                    } on UserNotFoundAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'No user found with this email',
                        );
                      }
                    } on WrongPasswordAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'Wrong credentials',
                        );
                      }
                    } on GenericAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'Authentification Error',
                        );
                      }
                    }
                  },
                  text: 'Login',
                ),
                // OTHER TEXT BUTTONS ---------------------------------------------------
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  child: Column(
                    children: [
                      MyText(
                        text: "Don't have an account yet?",
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      MyText(
                        text: 'Register',
                        color: Theme.of(context).colorScheme.inversePrimary,
                        textDecoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
