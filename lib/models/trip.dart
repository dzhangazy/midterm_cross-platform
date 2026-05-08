import 'package:json_annotation/json_annotation.dart';
import 'expense.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  final int? id;
  final String title;
  final String destination;
  final double budget;
  @JsonKey(defaultValue: false)
  final bool isCompleted;
  @JsonKey(defaultValue: [])
  final List<Expense> expenses;
  
  // Эти поля нужны для экрана аккаунта и других частей приложения
  final DateTime? startDate;
  final DateTime? endDate;

  Trip({
    this.id,
    required this.title,
    required this.destination,
    required this.budget,
    this.isCompleted = false,
    this.expenses = const [],
    this.startDate,
    this.endDate,
  });

  Trip copyWith({
    int? id,
    String? title,
    String? destination,
    double? budget,
    bool? isCompleted,
    List<Expense>? expenses,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      budget: budget ?? this.budget,
      isCompleted: isCompleted ?? this.isCompleted,
      expenses: expenses ?? this.expenses,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
