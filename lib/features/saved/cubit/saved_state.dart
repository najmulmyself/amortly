import 'package:equatable/equatable.dart';
import '../models/saved_calculation.dart';

class SavedState extends Equatable {
  final List<SavedCalculation> loans;
  final String searchQuery;
  final bool isLoading;

  const SavedState({
    this.loans = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<SavedCalculation> get filtered {
    if (searchQuery.isEmpty) return loans;
    final q = searchQuery.toLowerCase();
    return loans.where((l) => l.name.toLowerCase().contains(q)).toList();
  }

  SavedState copyWith({
    List<SavedCalculation>? loans,
    String? searchQuery,
    bool? isLoading,
  }) {
    return SavedState(
      loans: loans ?? this.loans,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [loans, searchQuery, isLoading];
}
