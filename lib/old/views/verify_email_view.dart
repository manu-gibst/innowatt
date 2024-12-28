import 'package:flutter/material.dart';
import 'package:innowatt/constants/routes.dart';
import 'package:innowatt/old/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text(
              "Please confirm your account. We've sent you email verification."),
          const Text(
              "If you haven't received an email, click the button below"),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send email verification"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              }
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
