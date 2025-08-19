import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:cocinando_con_flow/src/feature/detalle/data/services/detalle_api_service.dart';

import 'detalle_api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('DetalleApiService', () {
    late DetalleApiService detalleApiService;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      detalleApiService = DetalleApiService(dio: mockDio);
    });

    group('obtenerRecetaPorId', () {
      const recetaId = '12345';
      const apiUrl = 'https://www.themealdb.com/api/json/v1/1/lookup.php';

      test('debe retornar receta cuando la API responde exitosamente', () async {
        // Arrange
        final responseData = {
          'meals': [
            {
              'idMeal': recetaId,
              'strMeal': 'Receta de Prueba',
              'strMealThumb': 'https://ejemplo.com/imagen.jpg',
              'strCategory': 'Categoría Test',
              'strArea': 'Área Test',
              'strInstructions': 'Instrucciones de prueba',
              'strIngredient1': 'Ingrediente 1',
              'strIngredient2': 'Ingrediente 2',
              'strMeasure1': '100g',
              'strMeasure2': '200ml',
            }
          ]
        };

        final response = Response(
          data: responseData,
          requestOptions: RequestOptions(path: apiUrl),
          statusCode: 200,
        );

        when(mockDio.get(apiUrl, queryParameters: {'i': recetaId}))
            .thenAnswer((_) async => response);

        // Act
        final resultado = await detalleApiService.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNotNull);
        expect(resultado!.idMeal, recetaId);
        expect(resultado.strMeal, 'Receta de Prueba');
        expect(resultado.strCategory, 'Categoría Test');
        expect(resultado.strArea, 'Área Test');
        expect(resultado.strInstructions, 'Instrucciones de prueba');
        expect(resultado.strIngredient1, 'Ingrediente 1');
        expect(resultado.strIngredient2, 'Ingrediente 2');
        expect(resultado.strMeasure1, '100g');
        expect(resultado.strMeasure2, '200ml');

        verify(mockDio.get(apiUrl, queryParameters: {'i': recetaId})).called(1);
      });

      test('debe retornar null cuando la API no encuentra la receta', () async {
        // Arrange
        final responseData = {'meals': null};

        final response = Response(
          data: responseData,
          requestOptions: RequestOptions(path: apiUrl),
          statusCode: 200,
        );

        when(mockDio.get(apiUrl, queryParameters: {'i': recetaId}))
            .thenAnswer((_) async => response);

        // Act
        final resultado = await detalleApiService.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNull);
        verify(mockDio.get(apiUrl, queryParameters: {'i': recetaId})).called(1);
      });

      test('debe retornar null cuando la API retorna lista vacía', () async {
        // Arrange
        final responseData = {'meals': []};

        final response = Response(
          data: responseData,
          requestOptions: RequestOptions(path: apiUrl),
          statusCode: 200,
        );

        when(mockDio.get(apiUrl, queryParameters: {'i': recetaId}))
            .thenAnswer((_) async => response);

        // Act
        final resultado = await detalleApiService.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNull);
        verify(mockDio.get(apiUrl, queryParameters: {'i': recetaId})).called(1);
      });

      test('debe manejar receta con ingredientes y medidas vacíos', () async {
        // Arrange
        final responseData = {
          'meals': [
            {
              'idMeal': recetaId,
              'strMeal': 'Receta Vacía',
              'strMealThumb': 'https://ejemplo.com/imagen.jpg',
              'strCategory': 'Categoría Test',
              'strArea': 'Área Test',
              'strInstructions': 'Instrucciones de prueba',
              'strIngredient1': null,
              'strIngredient2': null,
              'strMeasure1': null,
              'strMeasure2': null,
            }
          ]
        };

        final response = Response(
          data: responseData,
          requestOptions: RequestOptions(path: apiUrl),
          statusCode: 200,
        );

        when(mockDio.get(apiUrl, queryParameters: {'i': recetaId}))
            .thenAnswer((_) async => response);

        // Act
        final resultado = await detalleApiService.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNotNull);
        expect(resultado!.strIngredient1, isNull);
        expect(resultado.strIngredient2, isNull);
        expect(resultado.strMeasure1, isNull);
        expect(resultado.strMeasure2, isNull);

        verify(mockDio.get(apiUrl, queryParameters: {'i': recetaId})).called(1);
      });

      test('debe propagar error cuando la API falla', () async {
        // Arrange
        when(mockDio.get(apiUrl, queryParameters: {'i': recetaId}))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: apiUrl),
              error: 'Error de red',
            ));

        // Act & Assert
        expect(
          () => detalleApiService.obtenerRecetaPorId(recetaId),
          throwsA(isA<DioException>()),
        );

        verify(mockDio.get(apiUrl, queryParameters: {'i': recetaId})).called(1);
      });

      test('debe propagar error cuando la respuesta no tiene el formato esperado', () async {
        // Arrange
        final responseData = {'error': 'Formato inválido'};

        final response = Response(
          data: responseData,
          requestOptions: RequestOptions(path: apiUrl),
          statusCode: 200,
        );

        when(mockDio.get(apiUrl, queryParameters: {'i': recetaId}))
            .thenAnswer((_) async => response);

        // Act
        final resultado = await detalleApiService.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNull);
        verify(mockDio.get(apiUrl, queryParameters: {'i': recetaId})).called(1);
      });

      test('debe construir URL correctamente con el ID de receta', () async {
        // Arrange
        const otroId = '67890';
        const otraUrl = 'https://www.themealdb.com/api/json/v1/1/lookup.php';

        final responseData = {'meals': null};

        final response = Response(
          data: responseData,
          requestOptions: RequestOptions(path: otraUrl),
          statusCode: 200,
        );

        when(mockDio.get(otraUrl, queryParameters: {'i': otroId}))
            .thenAnswer((_) async => response);

        // Act
        await detalleApiService.obtenerRecetaPorId(otroId);

        // Assert
        verify(mockDio.get(otraUrl, queryParameters: {'i': otroId})).called(1);
      });
    });
  });
}
