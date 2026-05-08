import '../models/models.dart';

abstract class Repository {
  Future<List<Trip>> findAllTrips();
  Future<List<Expense>> findAllExpenses();

  Stream<List<Trip>> watchAllTrips();
  Stream<List<Expense>> watchAllExpenses();

  Future<void> insertTrip(Trip trip);
  Future<void> insertExpense(Expense expense);
  
  Future<void> deleteTrip(Trip trip);
  Future<void> deleteExpense(Expense expense);
  
  Future<void> toggleTripCompletion(Trip trip);
  
  Future<void> syncWithApi();

  void close();
}
