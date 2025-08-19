import 'package:dio/dio.dart';
import 'package:cocinando_con_flow/src/shared/data/models/models.dart';
import 'package:cocinando_con_flow/src/shared/network/dio_config.dart';

class DetalleApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final Dio _dio;

  DetalleApiService({Dio? dio}) : _dio = dio ?? DioConfig.createDio();

  Future<RecetaModel?> obtenerRecetaPorId(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/lookup.php', queryParameters: {'i': id});
      if (response.statusCode == 200 && response.data['meals'] != null) {
        final List<dynamic> meals = response.data['meals'];
        if (meals.isNotEmpty) {
          return RecetaModel.fromJson(meals.first);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
