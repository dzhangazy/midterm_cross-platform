import '../models/trip.dart';
import '../models/expense.dart';

abstract class Repository {
  Future<List<Trip>> findAllTrips();
  Future<List<Expense>> findAllExpenses();


  Stream<List<Trip>> watchAllTrips();
  Stream<List<Expense>> watchAllExpenses();


  Future<void> insertTrip(Trip trip);
  Future<void> insertExpense(Expense expense);
  
  Future<void> deleteTrip(Trip trip);
  

  void close();
}
