import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tracker_state.dart';
import '../models/trip.dart';
import '../models/expense.dart';
import '../api/tracker_service.dart';
import 'repository.dart';

class TripRepository extends StateNotifier<TrackerState> implements Repository {
  TripRepository() : super(const TrackerState());

  @override
  Future<List<Trip>> findAllTrips() async => state.trips;

  @override
  Future<List<Expense>> findAllExpenses() async => state.currentExpenses;

  @override
  Stream<List<Trip>> watchAllTrips() => Stream.value(state.trips);

  @override
  Stream<List<Expense>> watchAllExpenses() => Stream.value(state.currentExpenses);

  @override
  Future<void> insertTrip(Trip trip) async {
    state = state.copyWith(trips: [...state.trips, trip]);
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    state = state.copyWith(
      currentExpenses: [...state.currentExpenses, expense],
      currentSpending: state.currentSpending + expense.amount,
    );
  }

  @override
  Future<void> deleteTrip(Trip trip) async {
    state = state.copyWith(
      trips: state.trips.where((t) => t.id != trip.id).toList(),
    );
  }

  @override
  void close() {
  }
}

// Провайдер репозитория
final tripRepositoryProvider =
    StateNotifierProvider<TripRepository, TrackerState>((ref) {
  return TripRepository();
});


final trackerServiceProvider = Provider<TrackerService>((ref) {
  return TrackerService.create();
});
