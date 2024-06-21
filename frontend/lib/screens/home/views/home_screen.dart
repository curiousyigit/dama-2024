import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:weight_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:weight_app/screens/home/views/about_screen.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
          child: const Icon(Icons.question_mark),
        ),
        appBar: AppBar(
          title: const Text('Weight App'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
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

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AuthBloc>(
//         create: (context) => AuthBloc(
//             weightAppService: context.read<AuthBloc>().weightAppService),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Weight App'),
//             centerTitle: true,
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             foregroundColor: Colors.white,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(AppLocalizations.of(context)!.name,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 18)),
//                   const Text('....', style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
