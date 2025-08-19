import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cocinando_con_flow/src/feature/detalle/data/repository/detalle_repository_impl.dart';
import 'package:cocinando_con_flow/src/feature/detalle/data/services/detalle_api_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';
import 'package:cocinando_con_flow/src/shared/data/models/models.dart';

import 'detalle_repository_impl_test.mocks.dart';

@GenerateMocks([DetalleApiService, LocalFavoritesService])
void main() {
  group('DetalleRepositoryImpl', () {
    late DetalleRepositoryImpl detalleRepository;
    late MockDetalleApiService mockApiService;
    late MockLocalFavoritesService mockFavoritesService;

    setUp(() {
      mockApiService = MockDetalleApiService();
      mockFavoritesService = MockLocalFavoritesService();
      detalleRepository = DetalleRepositoryImpl(
        apiService: mockApiService,
        favoritesService: mockFavoritesService,
      );
    });

    group('obtenerRecetaPorId', () {
      const recetaId = '12345';
      const recetaModelMock = RecetaModel(
        idMeal: recetaId,
        strMeal: 'Receta de Prueba',
        strMealThumb: 'https://ejemplo.com/imagen.jpg',
        strCategory: 'Categoría Test',
        strArea: 'Área Test',
        strInstructions: 'Instrucciones de prueba',
        strIngredient1: 'Ingrediente 1',
        strIngredient2: 'Ingrediente 2',
        strMeasure1: '100g',
        strMeasure2: '200ml',
      );

      test('debe retornar receta cuando la API responde exitosamente', () async {
        // Arrange
        when(mockApiService.obtenerRecetaPorId(recetaId))
            .thenAnswer((_) async => recetaModelMock);
        when(mockFavoritesService.esFavorito(recetaId))
            .thenAnswer((_) async => false);

        // Act
        final resultado = await detalleRepository.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNotNull);
        expect(resultado!.id, recetaId);
        expect(resultado.nombre, 'Receta de Prueba');
        expect(resultado.categoria, 'Categoría Test');
        expect(resultado.area, 'Área Test');
        expect(resultado.instrucciones, 'Instrucciones de prueba');
        expect(resultado.ingredientes, ['Ingrediente 1', 'Ingrediente 2']);
        expect(resultado.medidas, ['100g', '200ml']);
        expect(resultado.esFavorito, false);

        verify(mockApiService.obtenerRecetaPorId(recetaId)).called(1);
        verify(mockFavoritesService.esFavorito(recetaId)).called(1);
      });

      test('debe retornar null cuando la API no encuentra la receta', () async {
        // Arrange
        when(mockApiService.obtenerRecetaPorId(recetaId))
            .thenAnswer((_) async => null);

        // Act
        final resultado = await detalleRepository.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNull);
        verify(mockApiService.obtenerRecetaPorId(recetaId)).called(1);
        verifyNever(mockFavoritesService.esFavorito(any));
      });

      test('debe propagar error cuando la API falla', () async {
        // Arrange
        when(mockApiService.obtenerRecetaPorId(recetaId))
            .thenThrow(Exception('Error de red'));

        // Act & Assert
        expect(
          () => detalleRepository.obtenerRecetaPorId(recetaId),
          throwsA(isA<Exception>()),
        );

        verify(mockApiService.obtenerRecetaPorId(recetaId)).called(1);
        verifyNever(mockFavoritesService.esFavorito(any));
      });

      test('debe manejar receta con ingredientes y medidas vacíos', () async {
        // Arrange
        const recetaModelVacio = RecetaModel(
          idMeal: recetaId,
          strMeal: 'Receta Vacía',
          strMealThumb: 'https://ejemplo.com/imagen.jpg',
          strCategory: 'Categoría Test',
          strArea: 'Área Test',
          strInstructions: 'Instrucciones de prueba',
        );

        when(mockApiService.obtenerRecetaPorId(recetaId))
            .thenAnswer((_) async => recetaModelVacio);
        when(mockFavoritesService.esFavorito(recetaId))
            .thenAnswer((_) async => true);

        // Act
        final resultado = await detalleRepository.obtenerRecetaPorId(recetaId);

        // Assert
        expect(resultado, isNotNull);
        expect(resultado!.ingredientes, isEmpty);
        expect(resultado.medidas, isEmpty);
        expect(resultado.esFavorito, true);
      });
    });

    group('agregarAFavoritos', () {
      test('debe llamar al servicio de favoritos correctamente', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.agregar(recetaId))
            .thenAnswer((_) async {});

        // Act
        await detalleRepository.agregarAFavoritos(recetaId);

        // Assert
        verify(mockFavoritesService.agregar(recetaId)).called(1);
      });

      test('debe propagar error cuando falla agregar a favoritos', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.agregar(recetaId))
            .thenThrow(Exception('Error de base de datos'));

        // Act & Assert
        expect(
          () => detalleRepository.agregarAFavoritos(recetaId),
          throwsA(isA<Exception>()),
        );

        verify(mockFavoritesService.agregar(recetaId)).called(1);
      });
    });

    group('quitarDeFavoritos', () {
      test('debe llamar al servicio de favoritos correctamente', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.quitar(recetaId))
            .thenAnswer((_) async {});

        // Act
        await detalleRepository.quitarDeFavoritos(recetaId);

        // Assert
        verify(mockFavoritesService.quitar(recetaId)).called(1);
      });

      test('debe propagar error cuando falla quitar de favoritos', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.quitar(recetaId))
            .thenThrow(Exception('Error de base de datos'));

        // Act & Assert
        expect(
          () => detalleRepository.quitarDeFavoritos(recetaId),
          throwsA(isA<Exception>()),
        );

        verify(mockFavoritesService.quitar(recetaId)).called(1);
      });
    });

    group('esFavorito', () {
      test('debe retornar true cuando la receta es favorita', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.esFavorito(recetaId))
            .thenAnswer((_) async => true);

        // Act
        final resultado = await detalleRepository.esFavorito(recetaId);

        // Assert
        expect(resultado, true);
        verify(mockFavoritesService.esFavorito(recetaId)).called(1);
      });

      test('debe retornar false cuando la receta no es favorita', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.esFavorito(recetaId))
            .thenAnswer((_) async => false);

        // Act
        final resultado = await detalleRepository.esFavorito(recetaId);

        // Assert
        expect(resultado, false);
        verify(mockFavoritesService.esFavorito(recetaId)).called(1);
      });

      test('debe propagar error cuando falla verificar favorito', () async {
        // Arrange
        const recetaId = '12345';
        when(mockFavoritesService.esFavorito(recetaId))
            .thenThrow(Exception('Error de base de datos'));

        // Act & Assert
        expect(
          () => detalleRepository.esFavorito(recetaId),
          throwsA(isA<Exception>()),
        );

        verify(mockFavoritesService.esFavorito(recetaId)).called(1);
      });
    });
  });
}
