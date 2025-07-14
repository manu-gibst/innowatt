import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:innowatt/projects/single_project/rename_project/cubit/rename_project_cubit.dart';

class SingleProjectSliverAppBar extends StatelessWidget {
  const SingleProjectSliverAppBar({
    super.key,
    required this.projectName,
    required this.onRenameProject,
  });

  final String projectName;
  final void Function(String value) onRenameProject;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RenameProjectCubit(
        name: projectName,
        onRename: onRenameProject,
      ),
      child: _SingleProjectSliverAppBar(),
    );
  }
}

class _SingleProjectSliverAppBar extends StatelessWidget {
  const _SingleProjectSliverAppBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<RenameProjectCubit>();

    return BlocBuilder<RenameProjectCubit, RenameProjectState>(
      builder: (context, state) {
        return SliverAppBar(
          toolbarHeight: kToolbarHeight + (cubit.state.editing ? 30 : 0),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          centerTitle: true,
          iconTheme: IconThemeData(color: colorScheme.primaryFixed, size: 20),
          title: cubit.state.editing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: cubit.state.status.isInitial
                          ? cubit.toggleEditing
                          : null,
                      icon: Icon(Icons.close, color: colorScheme.error),
                    ),
                    SizedBox(width: 200, child: _NameInput()),
                    IconButton(
                      onPressed: cubit.state.status.isInitial
                          ? () async => await cubit.renameProject()
                          : null,
                      icon: Icon(Icons.done)
                          .loading(cubit.state.status.isInProgress),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 48),
                    Text(state.name.value),
                    IconButton(
                      onPressed: cubit.toggleEditing,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
          pinned: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<RenameProjectCubit>();
    final displayError = context
        .select((RenameProjectCubit cubit) => cubit.state.name.displayError);

    return TextFormField(
      initialValue: cubit.state.name.value,
      onTapOutside: (event) {
        if (event.position.dy > kToolbarHeight + 30) {
          cubit.toggleEditing();
        }
      },
      onFieldSubmitted: (_) async => await cubit.renameProject(),
      enabled: !cubit.state.status.isInProgressOrSuccess,
      onChanged: cubit.nameChanged,
      maxLength: 20,
      autofocus: true,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.words,
      style:
          textTheme.titleLarge?.copyWith(color: colorScheme.onPrimaryContainer),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: 'Project name',
        hintText: 'My New Project',
        errorText: displayError?.text(),
      ),
    );
  }
}

class SingleProjectSliver extends StatelessWidget {
  const SingleProjectSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

extension on Icon {
  Widget loading(bool isLoading) {
    if (!isLoading) return this;

    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(color: color),
    );
  }
}
