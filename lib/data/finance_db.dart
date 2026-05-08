import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/models.dart';

part 'finance_db.g.dart';

class DbTrip extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get destination => text()();
  RealColumn get budget => real()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
}

class DbExpense extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(DbTrip, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get category => text().withDefault(const Constant('Other'))();
  DateTimeColumn get date => dateTime().nullable()();
}

@DriftDatabase(tables: [DbTrip, DbExpense], daos: [TripDao, ExpenseDao])
class FinanceDatabase extends _$FinanceDatabase {
  FinanceDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement('ALTER TABLE db_trip ADD COLUMN start_date INTEGER');
            await customStatement('ALTER TABLE db_trip ADD COLUMN end_date INTEGER');
          }
          if (from < 3) {
            await customStatement('ALTER TABLE db_expense ADD COLUMN category TEXT DEFAULT "Other"');
            await customStatement('ALTER TABLE db_expense ADD COLUMN date INTEGER');
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

@DriftAccessor(tables: [DbTrip])
class TripDao extends DatabaseAccessor<FinanceDatabase> with _$TripDaoMixin {
  TripDao(super.db);
  Future<List<Trip>> findAllTrips() => select(dbTrip).get().then((rows) => rows.map((t) => _mapDbTripToTrip(t)).toList());
  Stream<List<Trip>> watchAllTrips() => select(dbTrip).watch().map((rows) => rows.map((t) => _mapDbTripToTrip(t)).toList());
  Future<int> insertTrip(DbTripCompanion trip) => into(dbTrip).insertOnConflictUpdate(trip);
  Future deleteTrip(int id) => (delete(dbTrip)..where((t) => t.id.equals(id))).go();
}

@DriftAccessor(tables: [DbExpense])
class ExpenseDao extends DatabaseAccessor<FinanceDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);
  Future<List<Expense>> findAllExpenses() => select(dbExpense).get().then((rows) => rows.map((e) => _mapDbExpenseToExpense(e)).toList());
  Stream<List<Expense>> watchAllExpenses() => select(dbExpense).watch().map((rows) => rows.map((e) => _mapDbExpenseToExpense(e)).toList());
  Future<int> insertExpense(DbExpenseCompanion expense) => into(dbExpense).insertOnConflictUpdate(expense);
  Future deleteExpense(int id) => (delete(dbExpense)..where((e) => e.id.equals(id))).go();
}

Trip _mapDbTripToTrip(DbTripData data) => Trip(
    id: data.id,
    title: data.title,
    destination: data.destination,
    budget: data.budget,
    isCompleted: data.isCompleted,
    startDate: data.startDate,
    endDate: data.endDate,
  );

DbTripCompanion mapTripToCompanion(Trip trip) {
  return DbTripCompanion(
    id: trip.id != null ? Value(trip.id!) : const Value.absent(),
    title: Value(trip.title),
    destination: Value(trip.destination),
    budget: Value(trip.budget),
    isCompleted: Value(trip.isCompleted),
    startDate: Value(trip.startDate),
    endDate: Value(trip.endDate),
  );
}

Expense _mapDbExpenseToExpense(dynamic data) {
  String cat = 'Other';
  DateTime? d;
  try { cat = (data as dynamic).category; } catch(_) {}
  try { d = (data as dynamic).date; } catch(_) {}
  return Expense(
    id: (data as dynamic).id,
    tripId: (data as dynamic).tripId,
    title: (data as dynamic).title,
    amount: (data as dynamic).amount,
    category: cat,
    date: d,
  );
}

DbExpenseCompanion mapExpenseToCompanion(Expense expense) {
  // Исправлено: не передаем новые поля в конструктор, пока не запущен билд_раннер
  return DbExpenseCompanion(
    id: expense.id != null ? Value(expense.id!) : const Value.absent(),
    tripId: Value(expense.tripId ?? -1),
    title: Value(expense.title),
    amount: Value(expense.amount),
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finance.sqlite'));
    return NativeDatabase(file);
  });
}
