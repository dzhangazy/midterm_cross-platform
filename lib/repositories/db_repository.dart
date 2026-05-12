import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/finance_db.dart';
import '../models/models.dart';
import '../api/tracker_service.dart';
import 'trip_repository.dart';

class DBRepository extends TripRepository {
  final FinanceDatabase? dbOverride;
  
  DBRepository({this.dbOverride});

  late final FinanceDatabase _db;
  StreamSubscription? _tripsSubscription;
  StreamSubscription? _expensesSubscription;

  @override
  CurrentTripData build() {
    _db = dbOverride ?? FinanceDatabase();
    
    _tripsSubscription = _db.tripDao.watchAllTrips().listen((trips) {
      state = state.copyWith(trips: trips);
    });

    _expensesSubscription = _db.expenseDao.watchAllExpenses().listen((expenses) {
      final spending = expenses.fold(0.0, (sum, e) => sum + e.amount);
      state = state.copyWith(currentExpenses: expenses, currentSpending: spending);
    });

    ref.onDispose(() => close());
    return const CurrentTripData();
  }

  @override
  Future<void> syncWithApi() async {
    state = state.copyWith(isLoading: true);
    try {
      final service = ref.read(trackerServiceProvider);
      final response = await service.getTrips();

      if (response.isSuccessful && response.body != null) {
        final remoteTrips = response.body!;
        await _db.transaction(() async {
          for (final trip in remoteTrips) {
            await insertTrip(trip);
          }
        });
      } else {
        await _loadDemoData();
      }
    } catch (e) {
      print('DBRepository: Network failed, loading local demo data instead.');
      await _loadDemoData();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _loadDemoData() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final demoTrips = [
      Trip(
        title: 'Euro Tour 2025',
        destination: 'Paris, Berlin, Prague',
        budget: 3500.0,
        startDate: DateTime(2025, 6, 1),
        endDate: DateTime(2025, 6, 15),
        expenses: [
          Expense(title: 'Flight to Paris', amount: 850.0, category: 'Transport', date: DateTime(2025, 6, 1)),
          Expense(title: 'Hotel de Ville', amount: 1200.0, category: 'Housing', date: DateTime(2025, 6, 2)),
        ],
      ),
    ];

    for (final trip in demoTrips) {
      await insertTrip(trip);
    }
  }

  @override
  Future<void> insertTrip(Trip trip) async {
    final companion = mapTripToCompanion(trip);
    final id = await _db.tripDao.insertTrip(companion);
    
    if (trip.expenses.isNotEmpty) {
      for (final expense in trip.expenses) {
        final expCompanion = mapExpenseToCompanion(expense.copyWith(tripId: id));
        await _db.expenseDao.insertExpense(expCompanion);
      }
    }
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    final companion = mapExpenseToCompanion(expense);
    await _db.expenseDao.insertExpense(companion);
  }

  @override
  Future<void> deleteTrip(Trip trip) async {
    if (trip.id != null) {
      // Logic: Explicitly delete associated expenses to ensure data integrity
      await _db.expenseDao.deleteExpensesForTrip(trip.id!);
      await _db.tripDao.deleteTrip(trip.id!);
    }
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    if (expense.id != null) {
      await _db.expenseDao.deleteExpense(expense.id!);
    }
  }

  @override
  Future<void> toggleTripCompletion(Trip trip) async {
    if (trip.id != null) {
      final updatedTrip = trip.copyWith(isCompleted: !trip.isCompleted);
      await insertTrip(updatedTrip);
    }
  }

  @override
  Future<List<Trip>> findAllTrips() => _db.tripDao.findAllTrips();

  @override
  Future<List<Expense>> findAllExpenses() => _db.expenseDao.findAllExpenses();

  @override
  Stream<List<Trip>> watchAllTrips() => _db.tripDao.watchAllTrips();

  @override
  Stream<List<Expense>> watchAllExpenses() => _db.expenseDao.watchAllExpenses();

  @override
  void close() {
    _tripsSubscription?.cancel();
    _expensesSubscription?.cancel();
    _db.close();
  }
}
