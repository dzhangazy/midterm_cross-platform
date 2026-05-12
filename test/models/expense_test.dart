import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/models.dart';

void main() {
  group('Expense', () {
    test('can instantiate with default values', () {
      // Arrange & Act
      final expense = Expense(
        title: 'Dinner',
        amount: 50.0,
      );

      // Assert
      expect(expense.title, equals('Dinner'));
      expect(expense.amount, equals(50.0));
      expect(expense.category, equals('Other'));
      expect(expense.tripId, isNull);
    });

    test('fromJson and toJson should be consistent', () {
      // Arrange
      final json = {
        'id': 10,
        'tripId': 1,
        'title': 'Lunch',
        'amount': 25.5,
        'category': 'Food',
        'date': '2025-06-02T12:00:00.000',
      };

      // Act
      final expense = Expense.fromJson(json);
      final resultJson = expense.toJson();

      // Assert
      expect(expense.id, equals(10));
      expect(expense.tripId, equals(1));
      expect(expense.category, equals('Food'));
      expect(resultJson['title'], equals('Lunch'));
      expect(resultJson['amount'], equals(25.5));
    });

    test('copyWith should create a new instance with updated values', () {
      // Arrange
      final expense = Expense(
        title: 'Taxi',
        amount: 15.0,
      );

      // Act
      final updatedExpense = expense.copyWith(
        amount: 20.0,
        category: 'Transport',
      );

      // Assert
      expect(updatedExpense.amount, equals(20.0));
      expect(updatedExpense.category, equals('Transport'));
      expect(updatedExpense.title, equals('Taxi'));
      expect(expense.amount, equals(15.0)); // Original unchanged
    });
  });
}
