import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:weight_app/screens/weight_entries/blocs/weight_entries_bloc/weight_entries_bloc.dart';
import 'package:weight_app/screens/weight_entries/views/weight_entries_list.dart';
import 'package:weight_app/screens/weight_entries/views/weight_entry_screen.dart';

class WeightEntriesScreen extends StatelessWidget {
  const WeightEntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.weightEntries),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {
            context.read<WeightEntriesBloc>().add(GetWeightEntries(1, append: false));
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeightEntriesList(),
            SizedBox(height: 75),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WeightEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
