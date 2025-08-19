import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_event.dart';

void main() {
  group('BusquedaEvent', () {
    test('EjecutarBusqueda debe extender Equatable y tener props', () {
      const e = EjecutarBusqueda('pollo');
      expect(e, isA<Equatable>());
      expect(e.props, ['pollo']);
    });

    test('LimpiarBusqueda debe extender Equatable y tener props vacíos', () {
      const e = LimpiarBusqueda();
      expect(e, isA<Equatable>());
      expect(e.props, isEmpty);
    });

    test('AgregarAFavoritos debe extender Equatable y tener props', () {
      const e = AgregarAFavoritos('id1');
      expect(e, isA<Equatable>());
      expect(e.props, ['id1']);
    });

    test('QuitarDeFavoritos debe extender Equatable y tener props', () {
      const e = QuitarDeFavoritos('id1');
      expect(e, isA<Equatable>());
      expect(e.props, ['id1']);
    });
  });
}
