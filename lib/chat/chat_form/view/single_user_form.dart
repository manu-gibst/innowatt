import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:innowatt/chat/chat_form/cubit/chat_form_cubit.dart';
import 'package:innowatt/repository/chat_repository/src/chat_repository.dart';

class SingleUserPopup<T> extends PopupRoute<T> {
  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'New Chat';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Center(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: UnconstrainedBox(
          child: BlocProvider(
            create: (context) {
              final uid =
                  context.read<AuthenticationRepository>().currentUser.id;
              return ChatFormCubit(
                chatRepository: ChatRepository(uid: uid),
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              );
            },
            child: _SingleUserForm(),
          ),
        ),
      ),
    );
  }
}

class _SingleUserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ChatFormCubit, ChatFormState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context).pop();
          } else if (state.status.isFailure) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage ?? 'Failure occured')),
              );
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ChatNameInput(),
              _CreateChatButton(),
            ],
          ),
        ));
  }
}

class _ChatNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context
        .select((ChatFormCubit cubit) => cubit.state.chatName.displayError);

    return TextField(
      key: const Key('chatForm_chatNameInput_textField'),
      onChanged: context.read<ChatFormCubit>().chatNameChanged,
      decoration: InputDecoration(
        labelText: 'Chat name',
        helperText: '',
        errorText: displayError?.text(),
      ),
    );
  }
}

class _CreateChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (ChatFormCubit cubit) => cubit.state.status.isInProgress,
    );
    final isValid = context.select(
      (ChatFormCubit cubit) => cubit.state.isValid,
    );

    return ElevatedButton(
      key: const Key('chatForm_createChatButton_elevatedButton'),
      onPressed: isValid ? context.read<ChatFormCubit>().formSubmitted : null,
      child: !isInProgress
          ? const Text('CREATE')
          : const CircularProgressIndicator(),
    );
  }
}
