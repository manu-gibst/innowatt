import 'package:flutter/material.dart';
import 'package:innowatt/old/components/button.dart';
import 'package:innowatt/old/components/spacings.dart';
import 'package:innowatt/old/components/text.dart';
import 'package:innowatt/old/components/text_field.dart';
import 'package:innowatt/constants/image_routes.dart';
import 'package:innowatt/constants/routes.dart';
import 'package:innowatt/old/services/auth/auth_exceptions.dart';
import 'package:innowatt/old/services/auth/auth_service.dart';
import 'package:innowatt/old/services/auth/auth_user.dart';
import 'package:innowatt/old/services/cloud/chat/firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:innowatt/old/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  color: Theme.of(context).colorScheme.primaryContainer,
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
                MyButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final AuthUser authUser =
                          await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );
                      // Add to firestore
                      await FirebaseChatCore.instance.createUserInFirestore(
                        types.User(
                          id: authUser.id,
                          firstName: email,
                        ),
                      );

                      if (context.mounted) {
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      }
                    } on WeakPasswordAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'Your password is weak',
                        );
                      }
                    } on EmailAlreadyInUseAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'Email is already in use',
                        );
                      }
                    } on InvalidEmailAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'Email is invalid',
                        );
                      }
                    } on GenericAuthException {
                      if (context.mounted) {
                        showErrorDialog(
                          context,
                          'Failed to register',
                        );
                      }
                    }
                  },
                  text: 'Register',
                ),
                // OTHER TEXT BUTTONS ---------------------------------------------------
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: Column(
                    children: [
                      MyText(
                        text: "Already have an account?",
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      MyText(
                        text: 'Login',
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
