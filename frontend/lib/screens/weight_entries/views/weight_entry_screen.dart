import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:weight_app/data/models/weight_entry.dart';
import 'package:weight_app/screens/weight_entries/blocs/weight_entries_bloc/weight_entries_bloc.dart';
import 'package:weight_app/components/my_text_field.dart';

class WeightEntryScreen extends StatefulWidget {
  final WeightEntry? weightEntry;

  const WeightEntryScreen({super.key, this.weightEntry});

  @override
  State<WeightEntryScreen> createState() => _WeightEntryScreenState();
}

class _WeightEntryScreenState extends State<WeightEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final kgController = TextEditingController();
  final notesController = TextEditingController();
  String? _errorMsg;
  Map<String, String>? _fieldErrors;

  @override
  void initState() {
    super.initState();
    if (widget.weightEntry != null) {
      kgController.text = widget.weightEntry!.kg.toString();
      notesController.text = widget.weightEntry!.notes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightEntriesBloc, WeightEntriesState>(
      listener: (context, state) {
        if (state.loading == false &&
            (state.errorMsg != null || state.errors != null)) {
          setState(() {
            _errorMsg =
                state.errorMsg ?? AppLocalizations.of(context)!.requestFailed;
            _fieldErrors =
                state.errors?.map((key, value) => MapEntry(key, value.first));
          });
        } else if (state.loading == false) {
          setState(() {
            kgController.clear();
            notesController.clear();
            _errorMsg = null;
            _fieldErrors = null;
          });
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.weightEntry == null
                ? AppLocalizations.of(context)!.createWeightEntry
                : AppLocalizations.of(context)!.editWeightEntry),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (state.errorMsg != null || state.errors != null) {
                  context.read<WeightEntriesBloc>().add(ClearErrors());
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      if (_errorMsg != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            _errorMsg!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyTextField(
                          controller: kgController,
                          hintText: AppLocalizations.of(context)!.weightKg,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.monitor_weight),
                          errorMsg: _fieldErrors?['kg'],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseFillField;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyTextField(
                          controller: notesController,
                          hintText: AppLocalizations.of(context)!.notes,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(Icons.notes),
                          errorMsg: _fieldErrors?['notes'],
                        ),
                      ),
                      const SizedBox(height: 20),
                      state.loading == false
                          ? Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _errorMsg = null;
                                          _fieldErrors = null;
                                          if (widget.weightEntry == null) {
                                            context
                                                .read<WeightEntriesBloc>()
                                                .add(
                                                  CreateWeightEntry(
                                                    kg: double.parse(
                                                        kgController.text),
                                                    notes: notesController.text,
                                                  ),
                                                );
                                          } else {
                                            context
                                                .read<WeightEntriesBloc>()
                                                .add(
                                                  UpdateWeightEntry(
                                                    id: widget.weightEntry!.id,
                                                    kg: double.parse(
                                                        kgController.text),
                                                    notes: notesController.text,
                                                  ),
                                                );
                                          }
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 5,
                                      ),
                                      child: Text(
                                        widget.weightEntry == null
                                            ? AppLocalizations.of(context)!
                                                .create
                                            : AppLocalizations.of(context)!
                                                .update,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.weightEntry != null) ...[
                                  const SizedBox(height: 20),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .confirmDelete),
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .deleteConfirmation),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .cancel),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<WeightEntriesBloc>()
                                                      .add(
                                                        DeleteWeightEntry(widget
                                                            .weightEntry!.id),
                                                      );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .delete),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 5,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
