import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:weight_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:weight_app/data/models/user.dart';
import 'package:weight_app/screens/users/blocs/users_bloc/users_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final usersBloc = UsersBloc(weightAppService: context.read<AuthBloc>().weightAppService);
        usersBloc.add(LoadUsers(1));
        return usersBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.users),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.usersOnlyAdminNote),
              Expanded(
                child: BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) {
                    if (state is UsersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UsersLoaded) {
                      return Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: state.users.length,
                                itemBuilder: (context, index) {
                                  User user = state.users[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(user.name),
                                        subtitle: Text(user.email),
                                        trailing: Text(user.isAdmin ? AppLocalizations.of(context)!.admin : AppLocalizations.of(context)!.user),
                                      ),
                                      if (index < state.users.length - 1)
                                        const Divider(height: 1),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: state.currentPage > 1
                                    ? () {
                                        context.read<UsersBloc>().add(LoadUsers(state.currentPage - 1));
                                      }
                                    : null,
                                child: Text(AppLocalizations.of(context)!.previous),
                              ),
                              Text('${state.currentPage} / ${state.lastPage}'),
                              ElevatedButton(
                                onPressed: state.currentPage < state.lastPage
                                    ? () {
                                        context.read<UsersBloc>().add(LoadUsers(state.currentPage + 1));
                                      }
                                    : null,
                                child: Text(AppLocalizations.of(context)!.next),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (state is UsersFailed) {
                      return Center(child: Text(AppLocalizations.of(context)!.requestFailed));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
