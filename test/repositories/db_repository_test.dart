import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:drift/drift.dart' hide isNotNull; // Resolve conflict
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yummy/data/finance_db.dart';
import 'package:yummy/models/models.dart';
import 'package:yummy/repositories/db_repository.dart';
import 'package:yummy/repositories/trip_repository.dart';

// Import the generated mocks
import 'db_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FinanceDatabase>(),
  MockSpec<TripDao>(),
  MockSpec<ExpenseDao>(),
])
void main() {
  late DBRepository repository;
  late MockFinanceDatabase mockDb;
  late MockTripDao mockTripDao;
  late MockExpenseDao mockExpenseDao;

  setUp(() {
    mockDb = MockFinanceDatabase();
    mockTripDao = MockTripDao();
    mockExpenseDao = MockExpenseDao();

    // Stub the DAOs
    when(mockDb.tripDao).thenReturn(mockTripDao);
    when(mockDb.expenseDao).thenReturn(mockExpenseDao);

    // Provide dummy watch streams to prevent errors during build()
    when(mockTripDao.watchAllTrips()).thenAnswer((_) => Stream.value([]));
    when(mockExpenseDao.watchAllExpenses()).thenAnswer((_) => Stream.value([]));

    final container = ProviderContainer(
      overrides: [
        tripRepositoryProvider.overrideWith(
          () => DBRepository(dbOverride: mockDb),
        ),
      ],
    );
    addTearDown(container.dispose);

    repository = container.read(tripRepositoryProvider.notifier) as DBRepository;
  });

  group('DBRepository', () {
    test('Initialization: can be instantiated with mocked database', () {
      // Assert
      expect(repository, isNotNull);
      // verify(...) without .called() checks for at least one call
      verify(mockDb.tripDao);
    });

    test('findAllTrips: correctly returns Trip models from DAO', () async {
      // Arrange
      final trips = [
        Trip(id: 1, title: 'London', destination: 'UK', budget: 500.0),
      ];
      
      when(mockTripDao.findAllTrips()).thenAnswer((_) async => trips);

      // Act
      final result = await repository.findAllTrips();

      // Assert
      expect(result.length, 1);
      expect(result.first.title, equals('London'));
      verify(mockTripDao.findAllTrips()).called(1);
    });

    test('insertTrip: calls TripDao.insertTrip exactly once', () async {
      // Arrange
      final trip = Trip(title: 'Hawaii', destination: 'USA', budget: 3000.0);
      when(mockTripDao.insertTrip(any)).thenAnswer((_) async => 1);

      // Act
      await repository.insertTrip(trip);

      // Assert
      verify(mockTripDao.insertTrip(any)).called(1);
    });

    test('deleteTrip: triggers deletion in both DAOs for cascade logic', () async {
      // Arrange
      final trip = Trip(id: 99, title: 'Old Trip', destination: 'None', budget: 0);
      
      // Act
      await repository.deleteTrip(trip);

      // Assert
      verify(mockExpenseDao.deleteExpensesForTrip(99)).called(1);
      verify(mockTripDao.deleteTrip(99)).called(1);
    });
  });
}
