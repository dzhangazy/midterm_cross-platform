import 'package:chopper/chopper.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

@ChopperApi()
abstract class TrackerService extends ChopperService {
  @Get(path: '/')
  Future<Response> getTrips();

  @Get(path: 'trips/{id}')
  Future<Response> getTripDetails(@Path('id') String tripId);

  @Post(path: 'expenses')
  Future<Response> addExpense(@Body() Map<String, dynamic> expenseData);

  @Get(path: 'currency/latest')
  Future<Response> getCurrencyRates(@Query('base') String baseCurrency);

  static TrackerService create() {

    final service = TrackerServiceMock();

    ChopperClient(
      baseUrl: Uri.parse('https://catfact.ninja/'),
      interceptors: [
        (Request request) async {
          final headers = Map<String, String>.from(request.headers);
          headers['Accept'] = 'application/json';
          headers['User-Agent'] = 'Mozilla/5.0';
          return request.copyWith(headers: headers);
        },
        HttpLoggingInterceptor(),
      ],
      converter: const JsonConverter(),
      services: [service],
    );

    return service;
  }
}

class TrackerServiceMock extends TrackerService {
  @override
  Future<Response> getTrips() async {
    // Используем встроенный геттер client из ChopperService
    return await client.get(Uri.parse('https://catfact.ninja/fact'));
  }

  final _dummyOk = http.Response('{"status": "ok"}', 200);

  @override
  Future<Response> getTripDetails(String tripId) async => Response(_dummyOk, null);

  @override
  Future<Response> addExpense(Map<String, dynamic> data) async => Response(_dummyOk, null);

  @override
  Future<Response> getCurrencyRates(String base) async => Response(_dummyOk, null);

  @override
  Type get definitionType => TrackerService;
}
