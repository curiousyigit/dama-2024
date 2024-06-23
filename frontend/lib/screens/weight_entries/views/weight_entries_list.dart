import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:weight_app/data/models/weight_entry.dart';
import 'package:weight_app/screens/weight_entries/blocs/weight_entries_bloc/weight_entries_bloc.dart';
import 'package:weight_app/screens/weight_entries/views/weight_entry_screen.dart';

class WeightEntriesList extends StatelessWidget {
  final showChart;

  const WeightEntriesList({super.key, this.showChart = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightEntriesBloc, WeightEntriesState>(
      builder: (context, state) {
        if (state.weightEntries.isNotEmpty &&
            state.errorMsg == null &&
            state.errors == null) {
          return Column(
            children: [
              if (showChart) ...{
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        minY: state.weightEntries.map((wE) => wE.kg).toList().reduce(math.min) - 10,
                        maxY: state.weightEntries.map((wE) => wE.kg).toList().reduce(math.max) + 10,
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(sideTitles: SideTitles())
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: state.weightEntries.map((wE) => FlSpot(wE.createdAt.millisecondsSinceEpoch.toDouble(), wE.kg)).toList(),
                            dotData: const FlDotData(show: true),
                            color: Colors.blue,
                            barWidth: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              },
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.weightEntries.length,
                itemBuilder: (context, index) {
                  WeightEntry weightEntry = state.weightEntries[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(DateFormat.yMMMMd()
                            .add_jm()
                            .format(weightEntry.createdAt)),
                        subtitle: Text(weightEntry.notes ?? '-'),
                        trailing: Text(weightEntry.kg.toString(),
                            style: const TextStyle(fontSize: 18)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeightEntryScreen(
                                    weightEntry: weightEntry)),
                          );
                        },
                      ),
                      if (index < state.weightEntries.length - 1)
                        const Divider(height: 1),
                    ],
                  );
                },
              ),
              if (!state.loading && !state.hasReachedMax) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<WeightEntriesBloc>()
                          .add(GetWeightEntries(state.currentPage + 1));
                    },
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.loadMore),
                  ),
                ),
              } else if (state.loading)
                const CircularProgressIndicator()
            ],
          );
        } else if (state.loading == false && state.errorMsg != null ||
            state.errors != null) {
          return Center(
              child: Text(AppLocalizations.of(context)!.requestFailed));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
