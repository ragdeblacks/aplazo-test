import 'package:dio/dio.dart';
import 'package:cocinando_con_flow/src/shared/data/models/models.dart';
import 'package:cocinando_con_flow/src/shared/network/dio_config.dart';

class BusquedaApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final Dio _dio;

  BusquedaApiService({Dio? dio}) : _dio = dio ?? DioConfig.createDio();

  Future<List<RecetaModel>> buscarRecetasPorNombre(String nombre) async {
    try {
      final response = await _dio.get('$_baseUrl/search.php', queryParameters: {'s': nombre});
      if (response.statusCode == 200 && response.data['meals'] != null) {
        final List<dynamic> meals = response.data['meals'];
        return meals.map((json) => RecetaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
