part of 'weight_entries_bloc.dart';

@immutable
abstract class WeightEntriesEvent {}

class GetWeightEntries extends WeightEntriesEvent {
  final int page;
  final bool append;

  GetWeightEntries(this.page, {this.append = true});
}

class CreateWeightEntry extends WeightEntriesEvent {
  final double kg;
  final String? notes;

  CreateWeightEntry({required this.kg, this.notes});
}

class UpdateWeightEntry extends WeightEntriesEvent {
  final String id;
  final double kg;
  final String? notes;

  UpdateWeightEntry({required this.id, required this.kg, this.notes});
}

class DeleteWeightEntry extends WeightEntriesEvent {
  final String id;

  DeleteWeightEntry(this.id);
}

class ClearErrors extends WeightEntriesEvent {}