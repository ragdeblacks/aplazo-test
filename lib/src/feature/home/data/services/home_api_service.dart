import 'package:dio/dio.dart';
import '../models/receta_lista_model.dart';
import 'package:cocinando_con_flow/src/shared/network/dio_config.dart';

class HomeApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  HomeApiService() : _dio = DioConfig.createDio();

  Future<List<RecetaListaModel>> obtenerRecetas({
    int pagina = 1,
    int limite = 20,
  }) async {
    try {
      final charCode = 'a'.codeUnitAt(0) + (pagina - 1);
      final char = String.fromCharCode(charCode);
      if (charCode > 'z'.codeUnitAt(0)) return [];

      final response = await _dio.get('$_baseUrl/search.php?f=$char');
      
      if (response.statusCode == 200 && response.data['meals'] != null) {
        final List<dynamic> meals = response.data['meals'];
        final recetas = meals.take(limite).map((meal) {
          return RecetaListaModel.fromJson(meal);
        }).toList();
        
        return recetas;
      }
      
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
