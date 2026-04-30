import 'trip.dart';
import 'expense.dart';

class TrackerState {
  final List<Trip> trips;
  final List<Expense> currentExpenses;
  final double currentSpending;

  const TrackerState({
    this.trips = const [],
    this.currentExpenses = const [],
    this.currentSpending = 0.0,
  });

  TrackerState copyWith({
    List<Trip>? trips,
    List<Expense>? currentExpenses,
    double? currentSpending,
  }) {
    return TrackerState(
      trips: trips ?? this.trips,
      currentExpenses: currentExpenses ?? this.currentExpenses,
      currentSpending: currentSpending ?? this.currentSpending,
    );
  }
}
