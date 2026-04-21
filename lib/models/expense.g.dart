// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'title': instance.title,
      'amount': instance.amount,
      'currency': instance.currency,
      'category': instance.category,
      'date': instance.date.toIso8601String(),
    };
