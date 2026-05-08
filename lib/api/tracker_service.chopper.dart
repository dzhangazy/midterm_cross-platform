// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TrackerService extends TrackerService {
  _$TrackerService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TrackerService;

  @override
  Future<Response<List<Trip>>> getTrips() {
    final Uri $url = Uri.parse('trips');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Trip>, Trip>($request);
  }

  @override
  Future<Response<Trip>> getTripDetails(String tripId) {
    final Uri $url = Uri.parse('trips/${tripId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Trip, Trip>($request);
  }

  @override
  Future<Response<Trip>> addTrip(Trip trip) {
    final Uri $url = Uri.parse('trips');
    final $body = trip;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Trip, Trip>($request);
  }

  @override
  Future<Response<dynamic>> deleteTrip(String tripId) {
    final Uri $url = Uri.parse('trips/${tripId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Expense>> addExpense(Expense expense) {
    final Uri $url = Uri.parse('expenses');
    final $body = expense;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Expense, Expense>($request);
  }

  @override
  Future<Response<dynamic>> getCurrencyRates(String baseCurrency) {
    final Uri $url = Uri.parse('currency/latest');
    final Map<String, dynamic> $params = <String, dynamic>{
      'base': baseCurrency
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
