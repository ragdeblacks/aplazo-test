import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_event.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_state.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/entities/receta_lista_entity.dart';

void main() {
  group('HomeEvent', () {
    test('CargarRecetas extiende Equatable', () {
      const e = CargarRecetas();
      expect(e, isA<Equatable>());
      expect(e.props, isEmpty);
    });

    test('CargarMasRecetas extiende Equatable', () {
      const e = CargarMasRecetas();
      expect(e, isA<Equatable>());
      expect(e.props, isEmpty);
    });

    test('AgregarAFavoritos props', () {
      const e = AgregarAFavoritos('1');
      expect(e.props, ['1']);
    });

    test('QuitarDeFavoritos props', () {
      const e = QuitarDeFavoritos('1');
      expect(e.props, ['1']);
    });

    test('ActualizarFavoritos extiende Equatable', () {
      const e = ActualizarFavoritos();
      expect(e, isA<Equatable>());
      expect(e.props, isEmpty);
    });
  });

  group('HomeState', () {
    test('HomeInitial y HomeLoading extienden Equatable', () {
      expect(HomeInitial(), isA<Equatable>());
      expect(HomeLoading(), isA<Equatable>());
    });

    test('HomeLoaded props, equidad y copyWith', () {
      const r = RecetaListaEntity(id: '1', nombre: 'Pollo');
      const s1 = HomeLoaded(recetas: [r], paginaActual: 1, tieneMasPaginas: true);
      const s2 = HomeLoaded(recetas: [r], paginaActual: 1, tieneMasPaginas: true);
      expect(s1, equals(s2));
      final s3 = s1.copyWith(estaCargandoMas: true);
      expect(s3.estaCargandoMas, true);
      expect(s3.recetas, [r]);
    });

    test('HomeError props', () {
      const e = HomeError('fallo');
      expect(e.props, ['fallo']);
    });
  });
}
