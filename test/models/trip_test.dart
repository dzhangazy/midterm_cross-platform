import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/models.dart';

void main() {
  group('Trip', () {
    test('can instantiate with default values', () {
      // Arrange & Act
      final trip = Trip(
        title: 'Test Trip',
        destination: 'Test Destination',
        budget: 1000.0,
      );

      // Assert
      expect(trip.title, equals('Test Trip'));
      expect(trip.destination, equals('Test Destination'));
      expect(trip.budget, equals(1000.0));
      expect(trip.isCompleted, isFalse);
      expect(trip.expenses, isEmpty);
    });

    test('fromJson and toJson should be consistent', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Paris Trip',
        'destination': 'Paris, France',
        'budget': 2000.0,
        'isCompleted': true,
        'expenses': [],
        'startDate': '2025-06-01T00:00:00.000',
        'endDate': '2025-06-15T00:00:00.000',
      };

      // Act
      final trip = Trip.fromJson(json);
      final resultJson = trip.toJson();

      // Assert
      expect(trip.id, equals(1));
      expect(trip.title, equals('Paris Trip'));
      expect(trip.isCompleted, isTrue);
      expect(resultJson['title'], equals('Paris Trip'));
      expect(resultJson['budget'], equals(2000.0));
    });

    test('copyWith should create a new instance with updated values', () {
      // Arrange
      final trip = Trip(
        title: 'Original',
        destination: 'Old',
        budget: 100.0,
      );

      // Act
      final updatedTrip = trip.copyWith(
        title: 'New Title',
        budget: 500.0,
      );

      // Assert
      expect(updatedTrip.title, equals('New Title'));
      expect(updatedTrip.budget, equals(500.0));
      expect(updatedTrip.destination, equals('Old'));
      expect(trip.title, equals('Original')); // Original should remain unchanged
    });
  });
}
