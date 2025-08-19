import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/data/services/busqueda_api_service.dart';
import 'package:cocinando_con_flow/src/shared/data/models/receta_model.dart';

import 'busqueda_api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('BusquedaApiService', () {
    late BusquedaApiService service;
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      service = BusquedaApiService(dio: dio);
    });

    test('retorna lista cuando API responde con meals', () async {
      const url = 'https://www.themealdb.com/api/json/v1/1/search.php';
      final resp = Response(
        data: {
          'meals': [
            {'idMeal': '1', 'strMeal': 'Pollo'}
          ]
        },
        requestOptions: RequestOptions(path: url),
        statusCode: 200,
      );
      when(dio.get(url, queryParameters: {'s': 'pollo'}))
          .thenAnswer((_) async => resp);

      final r = await service.buscarRecetasPorNombre('pollo');
      expect(r, [const RecetaModel(idMeal: '1', strMeal: 'Pollo')]);
    });

    test('retorna vacío cuando no hay meals', () async {
      const url = 'https://www.themealdb.com/api/json/v1/1/search.php';
      final resp = Response(
        data: {'meals': null},
        requestOptions: RequestOptions(path: url),
        statusCode: 200,
      );
      when(dio.get(url, queryParameters: {'s': 'x'}))
          .thenAnswer((_) async => resp);

      final r = await service.buscarRecetasPorNombre('x');
      expect(r, isEmpty);
    });

    test('propaga error de Dio', () async {
      const url = 'https://www.themealdb.com/api/json/v1/1/search.php';
      when(dio.get(url, queryParameters: {'s': 'pollo'}))
          .thenThrow(DioException(requestOptions: RequestOptions(path: url)));

      expect(() => service.buscarRecetasPorNombre('pollo'), throwsA(isA<DioException>()));
    });
  });
}
