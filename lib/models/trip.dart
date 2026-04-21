import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudget;
  final String baseCurrency;

  Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    required this.baseCurrency,
  });

  /// Factory constructor for creating a new Trip instance from a map.
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  /// Method to convert a Trip instance to a map.
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
