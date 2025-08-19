import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_state.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/receta_entity.dart';

void main() {
  group('BusquedaState', () {
    test('BusquedaInicial extiende Equatable', () {
      expect(BusquedaInicial(), isA<Equatable>());
      expect(BusquedaInicial().props, isEmpty);
    });

    test('BusquedaCargando extiende Equatable', () {
      expect(BusquedaCargando(), isA<Equatable>());
      expect(BusquedaCargando().props, isEmpty);
    });

    test('BusquedaExitoso props y equidad', () {
      const receta = RecetaEntity(id: '1', nombre: 'Test');
      const s1 = BusquedaExitoso([receta]);
      const s2 = BusquedaExitoso([receta]);
      expect(s1.props, [const [receta]]);
      expect(s1, equals(s2));
    });

    test('BusquedaSinResultados extiende Equatable', () {
      expect(BusquedaSinResultados(), isA<Equatable>());
      expect(BusquedaSinResultados().props, isEmpty);
    });

    test('BusquedaError props', () {
      const e = BusquedaError('error');
      expect(e.props, ['error']);
    });
  });
}
