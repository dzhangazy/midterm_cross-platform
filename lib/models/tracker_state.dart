import 'trip.dart';
import 'expense.dart';

class CurrentTripData {
  final List<Trip> trips;
  final List<Expense> currentExpenses;
  final double currentSpending;
  final bool isLoading;

  const CurrentTripData({
    this.trips = const [],
    this.currentExpenses = const [],
    this.currentSpending = 0.0,
    this.isLoading = false,
  });

  // Получение трат по категориям для аналитики
  Map<String, double> get categorySpending {
    final Map<String, double> breakdown = {};
    for (var expense in currentExpenses) {
      breakdown[expense.category] = (breakdown[expense.category] ?? 0.0) + expense.amount;
    }
    return breakdown;
  }

  CurrentTripData copyWith({
    List<Trip>? trips,
    List<Expense>? currentExpenses,
    double? currentSpending,
    bool? isLoading,
  }) {
    return CurrentTripData(
      trips: trips ?? this.trips,
      currentExpenses: currentExpenses ?? this.currentExpenses,
      currentSpending: currentSpending ?? this.currentSpending,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
