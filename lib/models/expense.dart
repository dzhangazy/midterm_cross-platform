import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  final int? id;
  final int? tripId;
  final String title;
  final double amount;
  final String category;
  final DateTime? date;

  Expense({
    this.id,
    this.tripId,
    required this.title,
    required this.amount,
    this.category = 'Other',
    this.date,
  });

  Expense copyWith({
    int? id,
    int? tripId,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}
