import 'dart:convert';
import 'package:chopper/chopper.dart';
import '../models/models.dart';

class ModelConverter implements Converter {
  @override
  Request convertRequest(Request request) {
    final req = applyHeader(request, 'Content-Type', 'application/json');
    return req.copyWith(body: jsonEncode(req.body));
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    final body = response.body;
    final jsonRes = jsonDecode(body);

    // Логика конвертации для разных типов данных
    if (jsonRes is List) {
      final list = jsonRes.map((item) => _fromJson<InnerType>(item)).toList();
      return response.copyWith<BodyType>(body: list as BodyType);
    } else {
      final item = _fromJson<InnerType>(jsonRes);
      return response.copyWith<BodyType>(body: item as BodyType);
    }
  }

  dynamic _fromJson<T>(Map<String, dynamic> json) {
    if (T == Trip) return Trip.fromJson(json);
    if (T == Expense) return Expense.fromJson(json);
    return json;
  }
}
