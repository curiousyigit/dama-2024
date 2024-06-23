part of 'weight_entries_bloc.dart';

class WeightEntriesState extends Equatable {
  final List<WeightEntry> weightEntries;
  final int currentPage;
  final int lastPage;
  final bool hasReachedMax;
  final bool loading;
  final String? errorMsg;
  final Map<String, List<String>>? errors;

  const WeightEntriesState({
    this.weightEntries = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasReachedMax = false,
    this.loading = false,
    this.errorMsg,
    this.errors,
  });

  @override
  List<Object?> get props => [weightEntries, currentPage, lastPage, hasReachedMax, loading, errorMsg, errors];

  WeightEntriesState copyWith({List<WeightEntry>? weightEntries, int? currentPage, int? lastPage, bool? hasReachedMax, bool? loading, String? errorMsg, Map<String, List<String>>? errors}) {
    return WeightEntriesState(
      weightEntries: weightEntries ?? this.weightEntries,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loading: loading ?? this.loading,
      errorMsg: errorMsg ?? this.errorMsg,
      errors: errors ?? this.errors,
    );
  }

  WeightEntriesState copyWithoutErrors({List<WeightEntry>? weightEntries, int? currentPage, int? lastPage, bool? hasReachedMax, bool? loading}) {
    return WeightEntriesState(
      weightEntries: weightEntries ?? this.weightEntries,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loading: loading ?? this.loading,
    );
  }
}
