import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:weight_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:weight_app/screens/compass/views/compass_screen.dart';
import 'package:weight_app/screens/home/views/about_screen.dart';
import 'package:weight_app/screens/users/views/users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      // do nothing
    }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Weight App'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                      const SizedBox(height: 15),
                      Text(state.authUser!.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28)),
                      Text(state.authUser!.email,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                          leading: const Icon(Icons.gps_fixed),
                          title: Text(AppLocalizations.of(context)!.compass),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CompassScreen()),
                            );
                          }),
                      ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text(AppLocalizations.of(context)!.users,
                              style: TextStyle(
                                  color: state.authUser!.isAdmin
                                      ? null
                                      : Colors.grey)),
                          onTap: () {
                            if (state.authUser!.isAdmin) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UsersScreen()),
                              );
                            }
                          }),
                      ListTile(
                          leading: const Icon(Icons.question_mark),
                          title: Text(AppLocalizations.of(context)!.about),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AboutScreen()),
                            );
                          }),
                      const Divider(),
                      ListTile(
                          leading: const Icon(Icons.logout),
                          title: Text(AppLocalizations.of(context)!.logout),
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                Text(state.authUser!.name,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
