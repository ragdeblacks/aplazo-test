import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_bloc.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_event.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_state.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/repository/busqueda_repository.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/receta_entity.dart';

import 'busqueda_bloc_test.mocks.dart';

@GenerateMocks([BusquedaRepository])
void main() {
  group('BusquedaBloc', () {
    late BusquedaBloc bloc;
    late MockBusquedaRepository repo;

    setUp(() {
      repo = MockBusquedaRepository();
      bloc = BusquedaBloc(busquedaRepository: repo);
    });

    tearDown(() async {
      await bloc.close();
    });

    const receta = RecetaEntity(id: '1', nombre: 'Pollo');

    blocTest<BusquedaBloc, BusquedaState>(
      'EjecutarBusqueda vacío emite Inicial',
      build: () => bloc,
      act: (b) => b.add(const EjecutarBusqueda('  ')),
      expect: () => [BusquedaInicial()],
    );

    blocTest<BusquedaBloc, BusquedaState>(
      'EjecutarBusqueda exitoso emite [Cargando, Exitoso]',
      build: () {
        when(repo.buscarRecetasPorNombre('pollo')).thenAnswer((_) async => const [receta]);
        return bloc;
      },
      act: (b) => b.add(const EjecutarBusqueda('pollo')),
      expect: () => [
        BusquedaCargando(),
        const BusquedaExitoso([receta]),
      ],
      verify: (_) => verify(repo.buscarRecetasPorNombre('pollo')).called(1),
    );

    blocTest<BusquedaBloc, BusquedaState>(
      'EjecutarBusqueda sin resultados emite [Cargando, SinResultados]',
      build: () {
        when(repo.buscarRecetasPorNombre('x')).thenAnswer((_) async => const []);
        return bloc;
      },
      act: (b) => b.add(const EjecutarBusqueda('x')),
      expect: () => [BusquedaCargando(), BusquedaSinResultados()],
    );

    blocTest<BusquedaBloc, BusquedaState>(
      'EjecutarBusqueda error emite [Cargando, Error]',
      build: () {
        when(repo.buscarRecetasPorNombre('pollo')).thenThrow(Exception('fallo'));
        return bloc;
      },
      act: (b) => b.add(const EjecutarBusqueda('pollo')),
      expect: () => [
        BusquedaCargando(),
        const BusquedaError('Error en búsqueda: Exception: fallo'),
      ],
    );

    blocTest<BusquedaBloc, BusquedaState>(
      'LimpiarBusqueda emite Inicial',
      build: () => bloc,
      act: (b) => b.add(const LimpiarBusqueda()),
      expect: () => [BusquedaInicial()],
    );

    blocTest<BusquedaBloc, BusquedaState>(
      'AgregarAFavoritos actualiza lista cuando hay Exitoso',
      build: () => bloc,
      seed: () => const BusquedaExitoso([receta]),
      act: (b) {
        when(repo.agregarAFavoritos('1')).thenAnswer((_) async {});
        b.add(const AgregarAFavoritos('1'));
      },
      expect: () => [
        const BusquedaExitoso([RecetaEntity(id: '1', nombre: 'Pollo', esFavorito: true)]),
      ],
      verify: (_) => verify(repo.agregarAFavoritos('1')).called(1),
    );

    blocTest<BusquedaBloc, BusquedaState>(
      'QuitarDeFavoritos actualiza lista cuando hay Exitoso',
      build: () => bloc,
      seed: () => const BusquedaExitoso([RecetaEntity(id: '1', nombre: 'Pollo', esFavorito: true)]),
      act: (b) {
        when(repo.quitarDeFavoritos('1')).thenAnswer((_) async {});
        b.add(const QuitarDeFavoritos('1'));
      },
      expect: () => [
        const BusquedaExitoso([RecetaEntity(id: '1', nombre: 'Pollo', esFavorito: false)]),
      ],
      verify: (_) => verify(repo.quitarDeFavoritos('1')).called(1),
    );
  });
}
