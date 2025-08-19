import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_state.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

void main() {
  group('DetalleState', () {
    group('DetalleInitial', () {
      test('debe extender Equatable', () {
        expect(DetalleInitial(), isA<Equatable>());
      });

      test('debe tener props vacíos', () {
        final state = DetalleInitial();
        expect(state.props, isEmpty);
      });

      test('debe ser igual a otro DetalleInitial', () {
        final state1 = DetalleInitial();
        final state2 = DetalleInitial();
        expect(state1, equals(state2));
      });
    });

    group('DetalleLoading', () {
      test('debe extender Equatable', () {
        expect(DetalleLoading(), isA<Equatable>());
      });

      test('debe tener props vacíos', () {
        final state = DetalleLoading();
        expect(state.props, isEmpty);
      });

      test('debe ser igual a otro DetalleLoading', () {
        final state1 = DetalleLoading();
        final state2 = DetalleLoading();
        expect(state1, equals(state2));
      });
    });

    group('DetalleCargado', () {
      late RecetaEntity recetaMock;

      setUp(() {
        recetaMock = const RecetaEntity(
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
      });

      test('debe extender Equatable', () {
        expect(DetalleCargado(recetaMock), isA<Equatable>());
      });

      test('debe tener props correctos', () {
        final state = DetalleCargado(
          recetaMock,
          ingredientesExpandido: true,
          instruccionesExpandido: false,
        );
        expect(state.props, [recetaMock, true, false]);
      });

      test('debe tener valores por defecto correctos', () {
        final state = DetalleCargado(recetaMock);
        expect(state.ingredientesExpandido, false);
        expect(state.instruccionesExpandido, false);
      });

      test('debe ser igual cuando tiene los mismos valores', () {
        final state1 = DetalleCargado(
          recetaMock,
          ingredientesExpandido: true,
          instruccionesExpandido: false,
        );
        final state2 = DetalleCargado(
          recetaMock,
          ingredientesExpandido: true,
          instruccionesExpandido: false,
        );
        expect(state1, equals(state2));
      });

      test('debe ser diferente cuando tiene diferentes valores', () {
        final state1 = DetalleCargado(
          recetaMock,
          ingredientesExpandido: true,
          instruccionesExpandido: false,
        );
        final state2 = DetalleCargado(
          recetaMock,
          ingredientesExpandido: false,
          instruccionesExpandido: false,
        );
        expect(state1, isNot(equals(state2)));
      });

      group('copyWith', () {
        test('debe crear una nueva instancia con valores actualizados', () {
          final state = DetalleCargado(recetaMock);
          final newState = state.copyWith(
            ingredientesExpandido: true,
            instruccionesExpandido: true,
          );

          expect(newState.ingredientesExpandido, true);
          expect(newState.instruccionesExpandido, true);
          expect(newState.receta, equals(recetaMock));
        });

        test('debe mantener valores existentes cuando no se especifican', () {
          final state = DetalleCargado(
            recetaMock,
            ingredientesExpandido: true,
            instruccionesExpandido: false,
          );
          final newState = state.copyWith(ingredientesExpandido: false);

          expect(newState.ingredientesExpandido, false);
          expect(newState.instruccionesExpandido, false);
          expect(newState.receta, equals(recetaMock));
        });

        test('debe actualizar solo los campos especificados', () {
          final state = DetalleCargado(recetaMock);
          final newState = state.copyWith(ingredientesExpandido: true);

          expect(newState.ingredientesExpandido, true);
          expect(newState.instruccionesExpandido, false);
          expect(newState.receta, equals(recetaMock));
        });
      });
    });

    group('DetalleError', () {
      test('debe extender Equatable', () {
        expect(const DetalleError('Error de prueba'), isA<Equatable>());
      });

      test('debe tener props correctos', () {
        const state = DetalleError('Error de prueba');
        expect(state.props, ['Error de prueba']);
      });

      test('debe ser igual cuando tiene el mismo mensaje', () {
        const state1 = DetalleError('Error de prueba');
        const state2 = DetalleError('Error de prueba');
        expect(state1, equals(state2));
      });

      test('debe ser diferente cuando tiene diferente mensaje', () {
        const state1 = DetalleError('Error de prueba');
        const state2 = DetalleError('Otro error');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
