// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: (json['id'] as num?)?.toInt(),
      tripId: (json['tripId'] as num?)?.toInt(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'title': instance.title,
      'amount': instance.amount,
    };
