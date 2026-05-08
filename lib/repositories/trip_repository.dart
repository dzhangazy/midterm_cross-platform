import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../api/tracker_service.dart';
import 'repository.dart';

class TripRepository extends Notifier<CurrentTripData> implements Repository {
  @override
  CurrentTripData build() => const CurrentTripData();

  @override
  Future<List<Trip>> findAllTrips() async => state.trips;

  @override
  Future<List<Expense>> findAllExpenses() async => state.currentExpenses;

  @override
  Stream<List<Trip>> watchAllTrips() => Stream.value(state.trips);

  @override
  Stream<List<Expense>> watchAllExpenses() => Stream.value(state.currentExpenses);

  @override
  Future<void> insertTrip(Trip trip) async {}

  @override
  Future<void> insertExpense(Expense expense) async {}

  @override
  Future<void> deleteTrip(Trip trip) async {}

  @override
  Future<void> deleteExpense(Expense expense) async {}

  @override
  Future<void> toggleTripCompletion(Trip trip) async {}

  @override
  Future<void> syncWithApi() async {}

  @override
  void close() {}
}

final tripRepositoryProvider =
    NotifierProvider<TripRepository, CurrentTripData>(() {
  return TripRepository();
});

final trackerServiceProvider = Provider<TrackerService>((ref) {
  return TrackerService.create();
});
