// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      destination: json['destination'] as String,
      budget: (json['budget'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      expenses: (json['expenses'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'destination': instance.destination,
      'budget': instance.budget,
      'isCompleted': instance.isCompleted,
      'expenses': instance.expenses,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
