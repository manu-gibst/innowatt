import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/app/router/routes.dart';
import 'package:innowatt/constants/image_routes.dart';
import 'package:innowatt/auth/login/cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    logoImage,
                    height: 180,
                  ),
                  Expanded(
                    child: Text(
                      "Charge your business with InnoWatt!",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        fontSize: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _LoginButton(),
              const SizedBox(height: 8),
              _SignUpButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.email.displayError,
    );
    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'email',
        helperText: '',
        errorText: displayError?.text(),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.password.displayError,
    );
    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read<LoginCubit>().passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'password',
        helperText: '',
        errorText: displayError?.text(),
        errorStyle: TextStyle(overflow: TextOverflow.fade),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (LoginCubit cubit) => cubit.state.status.isInProgress,
    );

    final isValid = context.select(
      (LoginCubit cubit) => cubit.state.isValid,
    );

    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      onPressed: isValid
          ? () => context.read<LoginCubit>().logInWithCredentials()
          : null,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: !isInProgress
              ? const Text('LOGIN')
              : SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      label: const Text('SIGN IN WITH GOOGLE'),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => GoRouter.of(context).push(Routes.signUp),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: colorScheme.secondaryContainer),
      ),
    );
  }
}
