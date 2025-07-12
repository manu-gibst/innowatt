import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:innowatt/core/widgets/elevated_button.dart';
import 'package:innowatt/core/widgets/information_card.dart';
import 'package:innowatt/projects/cubit/create_project_cubit.dart';
import 'package:projects_repository/projects_repository.dart';

class CreateProjectWidget extends StatelessWidget {
  const CreateProjectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InformationCard(
          type: StatusType.neutral,
          title: "Looks like you don't have any projects yet",
          bottomButton: InformationButton(
            text: "Create new project",
            icon: null,
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return _CreateProjectDialog();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CreateProjectDialog extends StatelessWidget {
  const _CreateProjectDialog();

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationRepository>().currentUser.id;
    return BlocProvider(
      create: (context) => CreateProjectCubit(
        projectsRepository: ProjectsRepository(uid: uid),
      ),
      child: _CreateProjectDialogWrapper(),
    );
  }
}

class _CreateProjectDialogWrapper extends StatelessWidget {
  const _CreateProjectDialogWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateProjectCubit, CreateProjectState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Unknown Error'),
              ),
            );
        }
        if (state.status.isSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 64),
                    SizedBox(height: 16),
                    Text('Project created successfully!'),
                  ],
                ),
              ),
            ),
          );
          Future.delayed(Duration(seconds: 2), () {
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
            context.pop();
          });
        }
      },
      builder: (context, state) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AbsorbPointer(
            absorbing: state.status.isInProgressOrSuccess,
            child: AlertDialog(
              title: const Text("Create project"),
              content: _ProjectNameInput(),
              actions: [
                TextButton(
                  onPressed: context.pop,
                  child: const Text(
                    "Close",
                    textAlign: TextAlign.end,
                  ),
                ),
                ElevatedButton(
                  onPressed: context.read<CreateProjectCubit>().createProject,
                  style: customElevatedButtonStyle(context),
                  child: const Text("CREATE"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectNameInput extends StatelessWidget {
  const _ProjectNameInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context
        .select((CreateProjectCubit cubit) => cubit.state.name.displayError);
    final status =
        context.select((CreateProjectCubit cubit) => cubit.state.status);
    return TextField(
      key: const Key('createProjectWidget_projectNameInput_textField'),
      onChanged: (name) => context.read<CreateProjectCubit>().nameChanged(name),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'project name',
        hintText: 'My New Project',
        errorText: displayError?.text(),
      ),
      enabled: !status.isInProgressOrSuccess,
    );
  }
}
