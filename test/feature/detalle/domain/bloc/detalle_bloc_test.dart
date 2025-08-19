import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_bloc.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_event.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_state.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/repository/detalle_repository.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

import 'detalle_bloc_test.mocks.dart';

@GenerateMocks([DetalleRepository])
void main() {
  group('DetalleBloc', () {
    late DetalleBloc detalleBloc;
    late MockDetalleRepository mockDetalleRepository;

    setUp(() {
      mockDetalleRepository = MockDetalleRepository();
      detalleBloc = DetalleBloc(detalleRepository: mockDetalleRepository);
    });

    tearDown(() {
      detalleBloc.close();
    });

    group('CargarDetalle', () {
      const recetaId = '12345';
      const recetaMock = RecetaEntity(
        id: recetaId,
        nombre: 'Receta de Prueba',
        imagen: 'https://ejemplo.com/imagen.jpg',
        categoria: 'Categoría Test',
        area: 'Área Test',
        instrucciones: 'Instrucciones de prueba',
        ingredientes: ['Ingrediente 1', 'Ingrediente 2'],
        medidas: ['100g', '200ml'],
        esFavorito: false,
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe emitir [DetalleLoading, DetalleCargado] cuando se carga exitosamente',
        build: () {
          when(mockDetalleRepository.obtenerRecetaPorId(recetaId))
              .thenAnswer((_) async => recetaMock);
          return detalleBloc;
        },
        act: (bloc) => bloc.add(const CargarDetalle(recetaId)),
        expect: () => [
          DetalleLoading(),
          const DetalleCargado(
            recetaMock,
            ingredientesExpandido: false,
            instruccionesExpandido: false,
          ),
        ],
        verify: (_) {
          verify(mockDetalleRepository.obtenerRecetaPorId(recetaId)).called(1);
        },
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe emitir [DetalleLoading, DetalleError] cuando la receta no se encuentra',
        build: () {
          when(mockDetalleRepository.obtenerRecetaPorId(recetaId))
              .thenAnswer((_) async => null);
          return detalleBloc;
        },
        act: (bloc) => bloc.add(const CargarDetalle(recetaId)),
        expect: () => [
          DetalleLoading(),
          const DetalleError('Receta no encontrada'),
        ],
        verify: (_) {
          verify(mockDetalleRepository.obtenerRecetaPorId(recetaId)).called(1);
        },
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe emitir [DetalleLoading, DetalleError] cuando ocurre un error',
        build: () {
          when(mockDetalleRepository.obtenerRecetaPorId(recetaId))
              .thenThrow(Exception('Error de red'));
          return detalleBloc;
        },
        act: (bloc) => bloc.add(const CargarDetalle(recetaId)),
        expect: () => [
          DetalleLoading(),
          const DetalleError('Error al cargar detalle: Exception: Error de red'),
        ],
        verify: (_) {
          verify(mockDetalleRepository.obtenerRecetaPorId(recetaId)).called(1);
        },
      );
    });

    group('AgregarAFavoritos', () {
      const recetaId = '12345';
      const recetaMock = RecetaEntity(
        id: recetaId,
        nombre: 'Receta de Prueba',
        imagen: 'https://ejemplo.com/imagen.jpg',
        categoria: 'Categoría Test',
        area: 'Área Test',
        instrucciones: 'Instrucciones de prueba',
        ingredientes: ['Ingrediente 1', 'Ingrediente 2'],
        medidas: ['100g', '200ml'],
        esFavorito: false,
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe agregar receta a favoritos exitosamente',
        build: () {
          when(mockDetalleRepository.agregarAFavoritos(recetaId))
              .thenAnswer((_) async {});
          return detalleBloc;
        },
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const AgregarAFavoritos(recetaId)),
        expect: () => [
          DetalleCargado(
            recetaMock.copyWith(esFavorito: true),
            ingredientesExpandido: false,
            instruccionesExpandido: false,
          ),
        ],
        verify: (_) {
          verify(mockDetalleRepository.agregarAFavoritos(recetaId)).called(1);
        },
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe emitir DetalleError cuando falla agregar a favoritos',
        build: () {
          when(mockDetalleRepository.agregarAFavoritos(recetaId))
              .thenThrow(Exception('Error de base de datos'));
          return detalleBloc;
        },
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const AgregarAFavoritos(recetaId)),
        expect: () => [
          const DetalleError('Error al agregar a favoritos: Exception: Error de base de datos'),
        ],
        verify: (_) {
          verify(mockDetalleRepository.agregarAFavoritos(recetaId)).called(1);
        },
      );

      blocTest<DetalleBloc, DetalleState>(
        'no debe hacer nada si el estado no es DetalleCargado',
        build: () => detalleBloc,
        seed: () => DetalleLoading(),
        act: (bloc) => bloc.add(const AgregarAFavoritos(recetaId)),
        expect: () => [],
        verify: (_) {
          verifyNever(mockDetalleRepository.agregarAFavoritos(recetaId));
        },
      );
    });

    group('QuitarDeFavoritos', () {
      const recetaId = '12345';
      const recetaMock = RecetaEntity(
        id: recetaId,
        nombre: 'Receta de Prueba',
        imagen: 'https://ejemplo.com/imagen.jpg',
        categoria: 'Categoría Test',
        area: 'Área Test',
        instrucciones: 'Instrucciones de prueba',
        ingredientes: ['Ingrediente 1', 'Ingrediente 2'],
        medidas: ['100g', '200ml'],
        esFavorito: true,
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe quitar receta de favoritos exitosamente',
        build: () {
          when(mockDetalleRepository.quitarDeFavoritos(recetaId))
              .thenAnswer((_) async {});
          return detalleBloc;
        },
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const QuitarDeFavoritos(recetaId)),
        expect: () => [
          DetalleCargado(
            recetaMock.copyWith(esFavorito: false),
            ingredientesExpandido: false,
            instruccionesExpandido: false,
          ),
        ],
        verify: (_) {
          verify(mockDetalleRepository.quitarDeFavoritos(recetaId)).called(1);
        },
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe emitir DetalleError cuando falla quitar de favoritos',
        build: () {
          when(mockDetalleRepository.quitarDeFavoritos(recetaId))
              .thenThrow(Exception('Error de base de datos'));
          return detalleBloc;
        },
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const QuitarDeFavoritos(recetaId)),
        expect: () => [
          const DetalleError('Error al quitar de favoritos: Exception: Error de base de datos'),
        ],
        verify: (_) {
          verify(mockDetalleRepository.quitarDeFavoritos(recetaId)).called(1);
        },
      );
    });

    group('ToggleIngredientes', () {
      const recetaMock = RecetaEntity(
        id: '12345',
        nombre: 'Receta de Prueba',
        imagen: 'https://ejemplo.com/imagen.jpg',
        categoria: 'Categoría Test',
        area: 'Área Test',
        instrucciones: 'Instrucciones de prueba',
        ingredientes: ['Ingrediente 1', 'Ingrediente 2'],
        medidas: ['100g', '200ml'],
        esFavorito: false,
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe alternar estado de ingredientes expandido',
        build: () => detalleBloc,
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const ToggleIngredientes()),
        expect: () => [
          const DetalleCargado(
            recetaMock,
            ingredientesExpandido: true,
            instruccionesExpandido: false,
          ),
        ],
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe alternar de true a false el estado de ingredientes',
        build: () => detalleBloc,
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: true,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const ToggleIngredientes()),
        expect: () => [
          const DetalleCargado(
            recetaMock,
            ingredientesExpandido: false,
            instruccionesExpandido: false,
          ),
        ],
      );

      blocTest<DetalleBloc, DetalleState>(
        'no debe hacer nada si el estado no es DetalleCargado',
        build: () => detalleBloc,
        seed: () => DetalleLoading(),
        act: (bloc) => bloc.add(const ToggleIngredientes()),
        expect: () => [],
      );
    });

    group('ToggleInstrucciones', () {
      const recetaMock = RecetaEntity(
        id: '12345',
        nombre: 'Receta de Prueba',
        imagen: 'https://ejemplo.com/imagen.jpg',
        categoria: 'Categoría Test',
        area: 'Área Test',
        instrucciones: 'Instrucciones de prueba',
        ingredientes: ['Ingrediente 1', 'Ingrediente 2'],
        medidas: ['100g', '200ml'],
        esFavorito: false,
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe alternar estado de instrucciones expandido',
        build: () => detalleBloc,
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        ),
        act: (bloc) => bloc.add(const ToggleInstrucciones()),
        expect: () => [
          const DetalleCargado(
            recetaMock,
            ingredientesExpandido: false,
            instruccionesExpandido: true,
          ),
        ],
      );

      blocTest<DetalleBloc, DetalleState>(
        'debe alternar de true a false el estado de instrucciones',
        build: () => detalleBloc,
        seed: () => const DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: true,
        ),
        act: (bloc) => bloc.add(const ToggleInstrucciones()),
        expect: () => [
          const DetalleCargado(
            recetaMock,
            ingredientesExpandido: false,
            instruccionesExpandido: false,
          ),
        ],
      );
    });
  });
}
