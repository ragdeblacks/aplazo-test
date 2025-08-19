import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_event.dart';

void main() {
  group('DetalleEvent', () {
    group('CargarDetalle', () {
      test('debe extender Equatable', () {
        expect(const CargarDetalle('12345'), isA<Equatable>());
      });

      test('debe tener props correctos', () {
        const event = CargarDetalle('12345');
        expect(event.props, ['12345']);
      });

      test('debe ser igual cuando tiene el mismo recetaId', () {
        const event1 = CargarDetalle('12345');
        const event2 = CargarDetalle('12345');
        expect(event1, equals(event2));
      });

      test('debe ser diferente cuando tiene diferente recetaId', () {
        const event1 = CargarDetalle('12345');
        const event2 = CargarDetalle('67890');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('AgregarAFavoritos', () {
      test('debe extender Equatable', () {
        expect(const AgregarAFavoritos('12345'), isA<Equatable>());
      });

      test('debe tener props correctos', () {
        const event = AgregarAFavoritos('12345');
        expect(event.props, ['12345']);
      });

      test('debe ser igual cuando tiene el mismo recetaId', () {
        const event1 = AgregarAFavoritos('12345');
        const event2 = AgregarAFavoritos('12345');
        expect(event1, equals(event2));
      });
    });

    group('QuitarDeFavoritos', () {
      test('debe extender Equatable', () {
        expect(const QuitarDeFavoritos('12345'), isA<Equatable>());
      });

      test('debe tener props correctos', () {
        const event = QuitarDeFavoritos('12345');
        expect(event.props, ['12345']);
      });

      test('debe ser igual cuando tiene el mismo recetaId', () {
        const event1 = QuitarDeFavoritos('12345');
        const event2 = QuitarDeFavoritos('12345');
        expect(event1, equals(event2));
      });
    });

    group('ToggleIngredientes', () {
      test('debe extender Equatable', () {
        expect(const ToggleIngredientes(), isA<Equatable>());
      });

      test('debe tener props vacíos', () {
        const event = ToggleIngredientes();
        expect(event.props, isEmpty);
      });

      test('debe ser igual a otro ToggleIngredientes', () {
        const event1 = ToggleIngredientes();
        const event2 = ToggleIngredientes();
        expect(event1, equals(event2));
      });
    });

    group('ToggleInstrucciones', () {
      test('debe extender Equatable', () {
        expect(const ToggleInstrucciones(), isA<Equatable>());
      });

      test('debe tener props vacíos', () {
        const event = ToggleInstrucciones();
        expect(event.props, isEmpty);
      });

      test('debe ser igual a otro ToggleInstrucciones', () {
        const event1 = ToggleInstrucciones();
        const event2 = ToggleInstrucciones();
        expect(event1, equals(event2));
      });
    });
  });
}
