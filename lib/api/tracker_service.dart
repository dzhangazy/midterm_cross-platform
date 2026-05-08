import 'package:chopper/chopper.dart';
import 'dart:async';
import '../models/trip.dart';
import '../models/expense.dart';
import 'model_converter.dart';

part 'tracker_service.chopper.dart';

@ChopperApi()
abstract class TrackerService extends ChopperService {
  @Get(path: 'trips')
  Future<Response<List<Trip>>> getTrips();

  @Get(path: 'trips/{id}')
  Future<Response<Trip>> getTripDetails(@Path('id') String tripId);

  @Post(path: 'trips')
  Future<Response<Trip>> addTrip(@Body() Trip trip);

  @Delete(path: 'trips/{id}')
  Future<Response> deleteTrip(@Path('id') String tripId);

  @Post(path: 'expenses')
  Future<Response<Expense>> addExpense(@Body() Expense expense);

  @Get(path: 'currency/latest')
  Future<Response> getCurrencyRates(@Query('base') String baseCurrency);

  static TrackerService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://api.finance-tracker.com/'),
      interceptors: [
        (Request request) async {
          final headers = Map<String, String>.from(request.headers);
          headers['Accept'] = 'application/json';
          headers['Content-Type'] = 'application/json';
          return request.copyWith(headers: headers);
        },
        HttpLoggingInterceptor(),
      ],
      converter: ModelConverter(),
      services: [
        _$TrackerService(),
      ],
    );

    return _$TrackerService(client);
  }
}
