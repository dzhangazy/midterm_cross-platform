import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  final String id;
  final String tripId;
  final String title;
  final double amount;
  final String currency;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.date,
  });

  /// Factory constructor for creating a new Expense instance from a map.
  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  /// Method to convert an Expense instance to a map.
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}
